package com.dyota.api.auth.service;

import com.dyota.api.auth.domain.PasswordResetToken;
import com.dyota.api.auth.domain.User;
import com.dyota.api.auth.email.EmailService;
import com.dyota.api.auth.repository.PasswordResetTokenRepository;
import com.dyota.api.auth.repository.UserRepository;
import com.dyota.api.config.AppProperties;
import java.security.SecureRandom;
import java.time.Instant;
import java.util.Base64;
import java.util.UUID;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class PasswordResetService {

    private static final SecureRandom RANDOM = new SecureRandom();

    private final PasswordResetTokenRepository tokenRepo;
    private final UserRepository userRepo;
    private final PasswordEncoder encoder;
    private final EmailService emailService;
    private final RefreshTokenService refreshTokenService;
    private final AppProperties props;

    public PasswordResetService(
            PasswordResetTokenRepository tokenRepo,
            UserRepository userRepo,
            PasswordEncoder encoder,
            EmailService emailService,
            RefreshTokenService refreshTokenService,
            AppProperties props) {
        this.tokenRepo = tokenRepo;
        this.userRepo = userRepo;
        this.encoder = encoder;
        this.emailService = emailService;
        this.refreshTokenService = refreshTokenService;
        this.props = props;
    }

    @Transactional
    public void requestReset(String email) {
        userRepo.findByEmail(email).ifPresent(user -> {
            if (user.getPasswordHash() == null) {
                return;
            }
            String raw = randomBase64Url(32);
            PasswordResetToken t = new PasswordResetToken();
            t.setUserId(user.getId());
            t.setTokenHash(encoder.encode(raw));
            t.setExpiresAt(Instant.now().plus(props.email().resetTtl()));
            PasswordResetToken saved = tokenRepo.save(t);
            String composite = saved.getId() + "." + raw;
            emailService.sendPasswordResetEmail(user.getEmail(), composite);
        });
    }

    @Transactional
    public void reset(String composite, String newPassword) {
        Parsed parsed = parse(composite);
        if (parsed == null) {
            throw AuthException.invalidToken();
        }
        PasswordResetToken t = tokenRepo.findById(parsed.id).orElseThrow(AuthException::invalidToken);
        Instant now = Instant.now();
        if (t.getConsumedAt() != null) {
            throw AuthException.invalidToken();
        }
        if (now.isAfter(t.getExpiresAt())) {
            throw AuthException.tokenExpired();
        }
        if (!encoder.matches(parsed.raw, t.getTokenHash())) {
            throw AuthException.invalidToken();
        }
        User user = userRepo.findById(t.getUserId()).orElseThrow(AuthException::invalidToken);
        user.setPasswordHash(encoder.encode(newPassword));
        userRepo.save(user);
        t.setConsumedAt(now);
        tokenRepo.save(t);
        refreshTokenService.revokeAllForUser(user.getId());
    }

    private Parsed parse(String composite) {
        if (composite == null) {
            return null;
        }
        int dot = composite.indexOf('.');
        if (dot <= 0 || dot == composite.length() - 1) {
            return null;
        }
        try {
            return new Parsed(UUID.fromString(composite.substring(0, dot)), composite.substring(dot + 1));
        } catch (IllegalArgumentException e) {
            return null;
        }
    }

    private static String randomBase64Url(int bytes) {
        byte[] buf = new byte[bytes];
        RANDOM.nextBytes(buf);
        return Base64.getUrlEncoder().withoutPadding().encodeToString(buf);
    }

    private record Parsed(UUID id, String raw) {}
}
