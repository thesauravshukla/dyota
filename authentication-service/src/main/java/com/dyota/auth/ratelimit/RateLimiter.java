package com.dyota.auth.ratelimit;

import com.dyota.auth.config.AuthProperties;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.time.Duration;
import java.time.Instant;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;

/**
 * Fixed-window counters that deliberately outlive the sessions they count.
 *
 * <p>Counting rows in verification_session would have been simpler, but cleanup deletes
 * those rows within minutes, which would hand every caller a fresh budget as soon as
 * their sessions were swept. These counters are keyed by a SHA-256 digest, so no raw
 * identifier or IP is stored.
 */
@Component
public class RateLimiter {

    private static final String UPSERT = """
            INSERT INTO rate_counter (scope, scope_key, window_start, count, expires_at)
            VALUES (?, ?, ?, 1, ?)
            ON CONFLICT (scope, scope_key, window_start)
            DO UPDATE SET count = rate_counter.count + 1
            RETURNING count
            """;

    private final JdbcTemplate jdbc;
    private final AuthProperties properties;

    public RateLimiter(JdbcTemplate jdbc, AuthProperties properties) {
        this.jdbc = jdbc;
        this.properties = properties;
    }

    /**
     * Increments the counter and reports whether the caller is still within budget.
     * The increment happens even when over budget, so hammering the endpoint does not
     * let the window drain early.
     */
    public boolean tryConsume(RateScope scope, String rawKey, int limit, Instant now) {
        if (!properties.getRateLimit().isEnabled() || rawKey == null || rawKey.isBlank()) {
            return true;
        }
        Duration window = properties.getRateLimit().getWindow();
        Instant windowStart = floorToWindow(now, window);
        Instant expiresAt = windowStart.plus(window);

        Integer count = jdbc.queryForObject(
                UPSERT, Integer.class,
                scope.name(), hash(rawKey),
                java.sql.Timestamp.from(windowStart),
                java.sql.Timestamp.from(expiresAt));

        return count != null && count <= limit;
    }

    public Duration retryAfter(Instant now) {
        Duration window = properties.getRateLimit().getWindow();
        Instant windowEnd = floorToWindow(now, window).plus(window);
        return Duration.between(now, windowEnd);
    }

    public int purgeExpired(Instant now) {
        return jdbc.update("DELETE FROM rate_counter WHERE expires_at < ?",
                java.sql.Timestamp.from(now));
    }

    private static Instant floorToWindow(Instant now, Duration window) {
        long seconds = Math.max(1, window.getSeconds());
        return Instant.ofEpochSecond((now.getEpochSecond() / seconds) * seconds);
    }

    private static String hash(String raw) {
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] out = digest.digest(raw.getBytes(StandardCharsets.UTF_8));
            StringBuilder sb = new StringBuilder(out.length * 2);
            for (byte b : out) {
                sb.append(Character.forDigit((b >> 4) & 0xF, 16));
                sb.append(Character.forDigit(b & 0xF, 16));
            }
            return sb.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new IllegalStateException("SHA-256 unavailable", e);
        }
    }
}
