package com.dyota.oms.login;

import java.time.Instant;
import java.util.UUID;

public record LoginStarted(
        UUID sessionId,
        Instant otpExpiresAt,
        Instant resendAvailableAt,
        int sendsRemaining) {
}
