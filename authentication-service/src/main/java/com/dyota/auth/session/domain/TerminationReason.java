package com.dyota.auth.session.domain;

/** Why a session stopped. Kept only until the session row is swept away. */
public enum TerminationReason {
    VERIFIED,
    EXPIRED,
    ATTEMPTS_EXHAUSTED,
    SENDS_EXHAUSTED,
    CLIENT_TERMINATED
}
