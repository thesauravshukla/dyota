package com.dyota.api.auth.oauth;

import com.dyota.api.auth.domain.OAuthAccount;
import com.dyota.api.auth.domain.User;
import com.dyota.api.auth.repository.OAuthAccountRepository;
import com.dyota.api.auth.repository.UserRepository;
import java.time.Instant;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class OAuthService {

    private static final String PROVIDER_GOOGLE = "google";

    private final OAuthAccountRepository oauthRepo;
    private final UserRepository userRepo;
    private final GoogleTokenVerifier googleVerifier;

    public OAuthService(
            OAuthAccountRepository oauthRepo, UserRepository userRepo, GoogleTokenVerifier googleVerifier) {
        this.oauthRepo = oauthRepo;
        this.userRepo = userRepo;
        this.googleVerifier = googleVerifier;
    }

    @Transactional
    public User loginWithGoogle(String idToken) {
        GoogleIdTokenClaims claims = googleVerifier.verify(idToken);
        return oauthRepo
                .findByProviderAndSubject(PROVIDER_GOOGLE, claims.subject())
                .map(account -> userRepo.findById(account.getUserId()).orElseThrow())
                .orElseGet(() -> linkOrCreate(claims));
    }

    private User linkOrCreate(GoogleIdTokenClaims claims) {
        User user = userRepo.findByEmail(claims.email()).orElseGet(() -> {
            User newUser = new User();
            newUser.setEmail(claims.email());
            if (claims.emailVerified()) {
                newUser.setEmailVerifiedAt(Instant.now());
            }
            return userRepo.save(newUser);
        });
        OAuthAccount account = new OAuthAccount();
        account.setUserId(user.getId());
        account.setProvider(PROVIDER_GOOGLE);
        account.setSubject(claims.subject());
        account.setEmail(claims.email());
        oauthRepo.save(account);
        return user;
    }
}
