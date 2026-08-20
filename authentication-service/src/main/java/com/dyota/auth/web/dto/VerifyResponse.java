package com.dyota.auth.web.dto;

import com.dyota.auth.session.domain.IdentifierType;
import com.dyota.auth.verification.VerificationOutcome;
import java.time.Instant;
import java.util.UUID;

/**
 * A failed verification is a normal outcome and comes back 200 with verified=false, so
 * the login API branches on the body rather than on transport-level errors.
 */
public record VerifyResponse(
        boolean verified,
        boolean canLogin,
        String reason,
        Integer attemptsRemaining,
        UUID userId,
        String identifier,
        IdentifierType identifierType,
        Instant verifiedAt) {

    public static VerifyResponse from(VerificationOutcome o) {
        return new VerifyResponse(o.verified(), o.canLogin(), o.reason(), o.attemptsRemaining(),
                o.userId(), o.identifier(), o.identifierType(), o.verifiedAt());
    }
}
