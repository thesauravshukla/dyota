package com.dyota.oms.authclient;

import java.time.Instant;
import java.util.UUID;

public record OtpSendResult(
        UUID sessionId,
        Instant sessionExpiresAt,
        Instant otpExpiresAt,
        Instant resendAvailableAt,
        int sendsRemaining) {
}
