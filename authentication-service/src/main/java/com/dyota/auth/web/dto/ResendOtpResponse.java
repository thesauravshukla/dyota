package com.dyota.auth.web.dto;

import com.dyota.auth.verification.ResendResult;
import java.time.Instant;

public record ResendOtpResponse(
        Instant resendAvailableAt,
        Instant otpExpiresAt,
        int sendsRemaining,
        /** True only when the original code had expired and had to be replaced. */
        boolean newCodeIssued) {

    public static ResendOtpResponse from(ResendResult r) {
        return new ResendOtpResponse(r.resendAvailableAt(), r.otpExpiresAt(),
                r.sendsRemaining(), r.newCodeIssued());
    }
}
