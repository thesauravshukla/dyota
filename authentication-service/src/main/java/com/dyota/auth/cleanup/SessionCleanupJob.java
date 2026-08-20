package com.dyota.auth.cleanup;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

/**
 * Backstop for sessions nobody finished. Terminal transitions already delete inline
 * (or become eligible after the retention window), so this exists to collect abandoned
 * sessions rather than as the primary cleanup path.
 */
@Component
public class SessionCleanupJob {

    private static final Logger log = LoggerFactory.getLogger(SessionCleanupJob.class);

    private final SessionCleaner cleaner;

    public SessionCleanupJob(SessionCleaner cleaner) {
        this.cleaner = cleaner;
    }

    @Scheduled(
            fixedDelayString = "${auth.session.cleanup-interval}",
            initialDelayString = "${auth.session.cleanup-interval}")
    public void sweep() {
        try {
            // Keep draining while full batches come back, so a backlog clears promptly
            // instead of one batch per interval.
            int removed;
            int passes = 0;
            do {
                removed = cleaner.sweep();
                passes++;
            } while (removed > 0 && passes < 20);
        } catch (RuntimeException e) {
            log.error("Session cleanup sweep failed", e);
        }
    }
}
