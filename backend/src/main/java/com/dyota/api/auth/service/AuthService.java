package com.dyota.api.auth.service;

import com.dyota.api.auth.domain.RefreshToken;
import com.dyota.api.auth.domain.User;
import com.dyota.api.auth.oauth.OAuthService;
import com.dyota.api.auth.repository.UserRepository;
import com.dyota.api.config.AppProperties;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class AuthService {

    private final UserRepository userRepo;
    private final PasswordEncoder encoder;
    private final JwtService jwtService;
    private final RefreshTokenService refreshTokenService;
    private final EmailVerificationService verificationService;
    private final OAuthService oauthService;
    private final AppProperties props;

    public AuthService(
            UserRepository userRepo,
            PasswordEncoder encoder,
            JwtService jwtService,
            RefreshTokenService refreshTokenService,
            EmailVerificationService verificationService,
            OAuthService oauthService,
            AppProperties props) {
        this.userRepo = userRepo;
        this.encoder = encoder;
        this.jwtService = jwtService;
        this.refreshTokenService = refreshTokenService;
        this.verificationService = verificationService;
        this.oauthService = oauthService;
        this.props = props;
    }

    @Transactional
    public AuthResult signup(String email, String password, String confirmPassword) {
        if (!password.equals(confirmPassword)) {
            throw AuthException.passwordMismatch();
        }
        String normalised = email.trim().toLowerCase();
        if (userRepo.existsByEmail(normalised)) {
            throw AuthException.emailExists();
        }
        User user = new User();
        user.setEmail(normalised);
        user.setPasswordHash(encoder.encode(password));
        User saved = userRepo.save(user);
        verificationService.sendVerification(saved);
        return issueTokens(saved);
    }

    @Transactional
    public AuthResult login(String email, String password) {
        String normalised = email.trim().toLowerCase();
        User user = userRepo.findByEmail(normalised).orElseThrow(AuthException::invalidCredentials);
        if (user.getPasswordHash() == null) {
            throw AuthException.invalidCredentials();
        }
        if (!encoder.matches(password, user.getPasswordHash())) {
            throw AuthException.invalidCredentials();
        }
        return issueTokens(user);
    }

    @Transactional
    public AuthResult loginWithGoogle(String idToken) {
        User user = oauthService.loginWithGoogle(idToken);
        return issueTokens(user);
    }

    @Transactional
    public AuthResult refresh(String compositeRefreshToken) {
        RefreshToken existing = refreshTokenService
                .validate(compositeRefreshToken)
                .orElseThrow(AuthException::invalidRefresh);
        User user = userRepo.findById(existing.getUserId()).orElseThrow(AuthException::invalidRefresh);
        refreshTokenService.revoke(existing);
        return issueTokens(user);
    }

    @Transactional
    public void logout(String compositeRefreshToken) {
        refreshTokenService.validate(compositeRefreshToken).ifPresent(refreshTokenService::revoke);
    }

    private AuthResult issueTokens(User user) {
        String accessToken = jwtService.issueAccessToken(user);
        RefreshTokenService.Issued refresh = refreshTokenService.issue(user.getId());
        long expiresIn = props.jwt().accessTtl().toSeconds();
        return new AuthResult(accessToken, refresh.compositeToken(), expiresIn, user);
    }
}
