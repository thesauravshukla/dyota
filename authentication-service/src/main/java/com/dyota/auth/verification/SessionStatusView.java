package com.dyota.auth.verification;

import com.dyota.auth.session.domain.IdentifierType;
import com.dyota.auth.session.domain.Purpose;
import com.dyota.auth.session.domain.SessionStatus;
import java.time.Instant;
import java.util.UUID;

/** Read model for the status endpoint. Never exposes the code. */
public record SessionStatusView(
        UUID sessionId,
        SessionStatus status,
        IdentifierType identifierType,
        Purpose purpose,
        String maskedIdentifier,
        int sendCount,
        int sendsRemaining,
        int verifyAttempts,
        int attemptsRemaining,
        Instant createdAt,
        Instant expiresAt,
        Instant resendAvailableAt,
        Instant loginTime) {
}
