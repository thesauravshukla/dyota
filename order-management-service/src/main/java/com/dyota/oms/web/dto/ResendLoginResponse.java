package com.dyota.oms.web.dto;

import com.dyota.oms.authclient.OtpResendResult;
import java.time.Instant;

public record ResendLoginResponse(
        Instant resendAvailableAt,
        Instant otpExpiresAt,
        int sendsRemaining,
        boolean newCodeIssued) {

    public static ResendLoginResponse from(OtpResendResult r) {
        return new ResendLoginResponse(r.resendAvailableAt(), r.otpExpiresAt(),
                r.sendsRemaining(), r.newCodeIssued());
    }
}
