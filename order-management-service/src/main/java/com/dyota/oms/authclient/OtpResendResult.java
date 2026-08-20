package com.dyota.oms.authclient;

import java.time.Instant;

public record OtpResendResult(
        Instant resendAvailableAt,
        Instant otpExpiresAt,
        int sendsRemaining,
        boolean newCodeIssued) {
}
