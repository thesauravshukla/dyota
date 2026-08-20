package com.dyota.auth.verification;

import java.time.Instant;

public record ResendResult(
        Instant resendAvailableAt,
        Instant otpExpiresAt,
        int sendsRemaining,
        boolean newCodeIssued) {
}
