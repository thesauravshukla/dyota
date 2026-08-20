package com.dyota.oms.authclient;

import com.dyota.oms.support.IdentifierType;
import java.time.Instant;

public record OtpVerifyResult(
        boolean verified,
        boolean canLogin,
        String reason,
        Integer attemptsRemaining,
        String identifier,
        IdentifierType identifierType,
        Instant verifiedAt) {
}
