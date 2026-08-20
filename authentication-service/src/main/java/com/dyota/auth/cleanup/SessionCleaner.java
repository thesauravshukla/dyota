package com.dyota.auth.cleanup;

import com.dyota.auth.config.AuthProperties;
import com.dyota.auth.ratelimit.RateLimiter;
import com.dyota.auth.session.repository.VerificationSessionRepository;
import java.time.Clock;
import java.time.Instant;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

/** Transactional worker for the sweep. Split from the scheduler so the proxy applies. */
@Component
public class SessionCleaner {

    private static final Logger log = LoggerFactory.getLogger(SessionCleaner.class);

    /** Arbitrary but stable key identifying this service's sweep lock. */
    private static final long ADVISORY_LOCK_KEY = 8_431_207_155_001L;

    private final VerificationSessionRepository sessions;
    private final RateLimiter rateLimiter;
    private final AuthProperties properties;
    private final JdbcTemplate jdbc;
    private final Clock clock;

    public SessionCleaner(
            VerificationSessionRepository sessions,
            RateLimiter rateLimiter,
            AuthProperties properties,
            JdbcTemplate jdbc,
            Clock clock) {
        this.sessions = sessions;
        this.rateLimiter = rateLimiter;
        this.properties = properties;
        this.jdbc = jdbc;
        this.clock = clock;
    }

    /**
     * A transaction-scoped advisory lock, so exactly one replica sweeps and the lock is
     * released automatically at commit — no leak if this pod dies mid-sweep. The
     * connection-scoped variant would be unsafe here, since a pooled JdbcTemplate can
     * hand the unlock call a different connection than the lock.
     */
    @Transactional
    public int sweep() {
        Boolean acquired = jdbc.queryForObject(
                "SELECT pg_try_advisory_xact_lock(?)", Boolean.class, ADVISORY_LOCK_KEY);
        if (!Boolean.TRUE.equals(acquired)) {
            return 0;
        }

        Instant now = clock.instant();
        Instant terminatedBefore = now.minus(properties.getSession().getPostTerminalRetention());
        int batchSize = properties.getSession().getCleanupBatchSize();

        int removed = sessions.deleteFinishedBatch(now, terminatedBefore, batchSize);
        int counters = rateLimiter.purgeExpired(now);

        if (removed > 0 || counters > 0) {
            log.info("Cleanup removed {} session(s) and {} rate counter(s)", removed, counters);
        }
        return removed;
    }
}
