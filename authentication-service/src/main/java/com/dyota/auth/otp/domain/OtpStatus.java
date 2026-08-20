package com.dyota.auth.otp.domain;

/**
 * ACTIVE is constrained to at most one row per session by a partial unique index,
 * which is what makes "resend re-sends the same code" unambiguous.
 */
public enum OtpStatus {
    ACTIVE,
    CONSUMED,
    EXPIRED,
    SUPERSEDED
}
