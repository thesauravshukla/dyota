package com.dyota.auth.verification;

import java.time.Instant;
import java.util.UUID;

public record SendResult(
        UUID sessionId,
        Instant sessionExpiresAt,
        Instant otpExpiresAt,
        Instant resendAvailableAt,
        int sendsRemaining) {
}
