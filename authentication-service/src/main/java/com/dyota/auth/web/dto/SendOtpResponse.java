package com.dyota.auth.web.dto;

import com.dyota.auth.verification.SendResult;
import java.time.Instant;
import java.util.UUID;

public record SendOtpResponse(
        UUID sessionId,
        Instant sessionExpiresAt,
        Instant otpExpiresAt,
        Instant resendAvailableAt,
        int sendsRemaining) {

    public static SendOtpResponse from(SendResult r) {
        return new SendOtpResponse(r.sessionId(), r.sessionExpiresAt(), r.otpExpiresAt(),
                r.resendAvailableAt(), r.sendsRemaining());
    }
}
