package com.dyota.oms.web.dto;

import com.dyota.oms.login.LoginStarted;
import java.time.Instant;
import java.util.UUID;

public record StartLoginResponse(
        UUID sessionId,
        Instant otpExpiresAt,
        Instant resendAvailableAt,
        int sendsRemaining) {

    public static StartLoginResponse from(LoginStarted s) {
        return new StartLoginResponse(
                s.sessionId(), s.otpExpiresAt(), s.resendAvailableAt(), s.sendsRemaining());
    }
}
