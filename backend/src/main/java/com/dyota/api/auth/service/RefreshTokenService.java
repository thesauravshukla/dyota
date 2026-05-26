package com.dyota.api.auth.service;

import com.dyota.api.auth.domain.RefreshToken;
import com.dyota.api.auth.repository.RefreshTokenRepository;
import com.dyota.api.config.AppProperties;
import java.security.SecureRandom;
import java.time.Instant;
import java.util.Base64;
import java.util.Optional;
import java.util.UUID;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * Refresh token model: server returns "<uuid>.<rawSecret>" to the client; the
 * row stores only the bcrypt hash of <rawSecret>. Lookup by uuid avoids a
 * full-table scan.
 */
@Service
public class RefreshTokenService {

    private static final SecureRandom RANDOM = new SecureRandom();

    private final RefreshTokenRepository repo;
    private final PasswordEncoder encoder;
    private final AppProperties props;

    public RefreshTokenService(RefreshTokenRepository repo, PasswordEncoder encoder, AppProperties props) {
        this.repo = repo;
        this.encoder = encoder;
        this.props = props;
    }

    @Transactional
    public Issued issue(UUID userId) {
        String raw = randomBase64Url(32);
        RefreshToken rt = new RefreshToken();
        rt.setUserId(userId);
        rt.setTokenHash(encoder.encode(raw));
        rt.setExpiresAt(Instant.now().plus(props.jwt().refreshTtl()));
        RefreshToken saved = repo.save(rt);
        return new Issued(saved.getId(), saved.getId() + "." + raw);
    }

    /**
     * Validate "<uuid>.<rawSecret>"; return active row if valid.
     */
    public Optional<RefreshToken> validate(String composite) {
        Parsed parsed = parse(composite);
        if (parsed == null) {
            return Optional.empty();
        }
        return repo.findById(parsed.id())
                .filter(rt -> rt.isActive(Instant.now()))
                .filter(rt -> encoder.matches(parsed.raw(), rt.getTokenHash()));
    }

    @Transactional
    public void revoke(RefreshToken rt) {
        if (rt.getRevokedAt() == null) {
            rt.setRevokedAt(Instant.now());
            repo.save(rt);
        }
    }

    @Transactional
    public void revokeAllForUser(UUID userId) {
        repo.revokeAllForUser(userId, Instant.now());
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
            UUID id = UUID.fromString(composite.substring(0, dot));
            String raw = composite.substring(dot + 1);
            return new Parsed(id, raw);
        } catch (IllegalArgumentException e) {
            return null;
        }
    }

    private static String randomBase64Url(int bytes) {
        byte[] buf = new byte[bytes];
        RANDOM.nextBytes(buf);
        return Base64.getUrlEncoder().withoutPadding().encodeToString(buf);
    }

    public record Issued(UUID id, String compositeToken) {}

    private record Parsed(UUID id, String raw) {}
}
