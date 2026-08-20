package com.dyota.auth.session.domain;

/**
 * PENDING is the only non-terminal state. Everything else means the session is
 * finished and eligible for cleanup.
 */
public enum SessionStatus {
    PENDING,
    VERIFIED,
    LOCKED,
    EXPIRED;

    public boolean isTerminal() {
        return this != PENDING;
    }
}
