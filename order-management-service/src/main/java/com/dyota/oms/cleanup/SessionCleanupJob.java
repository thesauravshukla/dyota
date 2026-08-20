package com.dyota.oms.cleanup;

import com.dyota.oms.config.ServiceProperties;
import com.dyota.oms.session.repository.UserSessionRepository;
import java.time.Clock;
import java.time.Instant;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

/**
 * Live sessions are load-bearing and are never swept. This only removes rows that can no
 * longer authenticate anyone: logged-out sessions past their retention window, and any
 * that expired if absolute expiry is ever switched on.
 */
@Component
public class SessionCleanupJob {

    private static final Logger log = LoggerFactory.getLogger(SessionCleanupJob.class);

    private final UserSessionRepository sessions;
    private final ServiceProperties properties;
    private final Clock clock;

    public SessionCleanupJob(
            UserSessionRepository sessions, ServiceProperties properties, Clock clock) {
        this.sessions = sessions;
        this.properties = properties;
        this.clock = clock;
    }

    @Scheduled(
            fixedDelayString = "${oms.session.cleanup-interval}",
            initialDelayString = "${oms.session.cleanup-interval}")
    @Transactional
    public void sweep() {
        try {
            Instant now = clock.instant();
            int revoked = sessions.deleteRevokedBefore(
                    now.minus(properties.getSession().getRevokedRetention()));
            int expired = sessions.deleteExpiredBefore(now);
            if (revoked > 0 || expired > 0) {
                log.info("Cleanup removed {} revoked and {} expired session(s)", revoked, expired);
            }
        } catch (RuntimeException e) {
            log.error("Session cleanup sweep failed", e);
        }
    }
}
