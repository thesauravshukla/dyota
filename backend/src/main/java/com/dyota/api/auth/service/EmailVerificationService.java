package com.dyota.api.auth.service;

import com.dyota.api.auth.domain.EmailVerificationToken;
import com.dyota.api.auth.domain.User;
import com.dyota.api.auth.email.EmailService;
import com.dyota.api.auth.repository.EmailVerificationTokenRepository;
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
public class EmailVerificationService {

    private static final SecureRandom RANDOM = new SecureRandom();

    private final EmailVerificationTokenRepository tokenRepo;
    private final UserRepository userRepo;
    private final PasswordEncoder encoder;
    private final EmailService emailService;
    private final AppProperties props;

    public EmailVerificationService(
            EmailVerificationTokenRepository tokenRepo,
            UserRepository userRepo,
            PasswordEncoder encoder,
            EmailService emailService,
            AppProperties props) {
        this.tokenRepo = tokenRepo;
        this.userRepo = userRepo;
        this.encoder = encoder;
        this.emailService = emailService;
        this.props = props;
    }

    @Transactional
    public void sendVerification(User user) {
        if (user.isEmailVerified()) {
            return;
        }
        String raw = randomBase64Url(32);
        EmailVerificationToken t = new EmailVerificationToken();
        t.setUserId(user.getId());
        t.setTokenHash(encoder.encode(raw));
        t.setExpiresAt(Instant.now().plus(props.email().verificationTtl()));
        EmailVerificationToken saved = tokenRepo.save(t);
        String composite = saved.getId() + "." + raw;
        emailService.sendVerificationEmail(user.getEmail(), composite);
    }

    @Transactional
    public void resend(String email) {
        userRepo.findByEmail(email).ifPresent(this::sendVerification);
    }

    @Transactional
    public void confirm(String composite) {
        Parsed parsed = parse(composite);
        if (parsed == null) {
            throw AuthException.invalidToken();
        }
        EmailVerificationToken t = tokenRepo.findById(parsed.id).orElseThrow(AuthException::invalidToken);
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
        if (!user.isEmailVerified()) {
            user.setEmailVerifiedAt(now);
            userRepo.save(user);
        }
        t.setConsumedAt(now);
        tokenRepo.save(t);
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
