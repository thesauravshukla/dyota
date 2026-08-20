package com.dyota.auth.verification;

import com.dyota.auth.session.domain.IdentifierType;
import java.time.Instant;
import java.util.UUID;

/**
 * The answer the login API acts on. A failed verification is a normal outcome, not an
 * error, so it is reported here rather than thrown.
 */
public record VerificationOutcome(
        boolean verified,
        boolean canLogin,
        String reason,
        Integer attemptsRemaining,
        UUID userId,
        String identifier,
        IdentifierType identifierType,
        Instant verifiedAt) {

    public static VerificationOutcome success(
            UUID userId, String identifier, IdentifierType type, Instant verifiedAt) {
        return new VerificationOutcome(true, true, null, null, userId, identifier, type, verifiedAt);
    }

    public static VerificationOutcome failure(String reason, Integer attemptsRemaining) {
        return new VerificationOutcome(false, false, reason, attemptsRemaining, null, null, null, null);
    }
}
