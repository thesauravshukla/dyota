package com.dyota.oms.session.service;

import com.dyota.oms.config.ServiceProperties;
import com.dyota.oms.session.domain.UserSession;
import com.dyota.oms.session.repository.UserSessionRepository;
import java.time.Duration;
import java.time.Instant;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class SessionService {

    private static final Logger log = LoggerFactory.getLogger(SessionService.class);

    private final UserSessionRepository sessions;
    private final TokenFactory tokens;
    private final ServiceProperties properties;

    public SessionService(
            UserSessionRepository sessions, TokenFactory tokens, ServiceProperties properties) {
        this.sessions = sessions;
        this.tokens = tokens;
        this.properties = properties;
    }

    /** The raw token is returned exactly once here and never stored. */
    @Transactional
    public Issued open(UUID userId, String deviceLabel, Instant now) {
        enforcePerUserCap(userId, now);

        String raw = tokens.newToken();
        Duration ttl = properties.getSession().getTtl();
        UserSession session = UserSession.open(
                userId, tokens.hash(raw), deviceLabel, now, ttl == null ? null : now.plus(ttl));
        sessions.save(session);
        return new Issued(raw, session);
    }

    @Transactional
    public Optional<UserSession> authenticate(String rawToken, Instant now) {
        if (rawToken == null || rawToken.isBlank()) {
            return Optional.empty();
        }
        Optional<UserSession> found = sessions.findByTokenHash(tokens.hash(rawToken))
                .filter(s -> s.isActiveAt(now));
        // Rewriting last_used_at on every call would turn each read into a write, so it
        // is only refreshed once it has gone stale.
        found.ifPresent(session -> {
            Duration precision = properties.getSession().getLastUsedPrecision();
            if (session.getLastUsedAt().plus(precision).isBefore(now)) {
                session.touch(now);
            }
        });
        return found;
    }

    @Transactional
    public boolean revoke(String rawToken, Instant now) {
        return sessions.findByTokenHash(tokens.hash(rawToken))
                .filter(s -> s.isActiveAt(now))
                .map(session -> {
                    session.revoke(now);
                    return true;
                })
                .orElse(false);
    }

    @Transactional
    public int revokeAll(UUID userId, Instant now) {
        int revoked = sessions.revokeAllForUser(userId, now);
        log.info("Revoked {} session(s) for user {}", revoked, userId);
        return revoked;
    }

    @Transactional(readOnly = true)
    public List<UserSession> activeSessions(UUID userId) {
        return sessions.findByUserIdAndRevokedAtIsNullOrderByCreatedAtAsc(userId);
    }

    /**
     * Bounds table growth without ever expiring a token during normal use: opening a new
     * session past the cap revokes the least recently opened ones.
     */
    private void enforcePerUserCap(UUID userId, Instant now) {
        int max = properties.getSession().getMaxPerUser();
        if (max <= 0) {
            return;
        }
        List<UserSession> active = sessions.findByUserIdAndRevokedAtIsNullOrderByCreatedAtAsc(userId);
        int excess = active.size() - (max - 1);
        for (int i = 0; i < excess && i < active.size(); i++) {
            active.get(i).revoke(now);
            log.info("Session cap reached for user {}; revoked oldest session", userId);
        }
    }

    public record Issued(String token, UserSession session) {
    }
}
