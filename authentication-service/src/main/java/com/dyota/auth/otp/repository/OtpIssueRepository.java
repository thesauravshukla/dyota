package com.dyota.auth.otp.repository;

import com.dyota.auth.otp.domain.OtpIssue;
import com.dyota.auth.otp.domain.OtpStatus;
import java.util.Optional;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;

public interface OtpIssueRepository extends JpaRepository<OtpIssue, UUID> {

    /**
     * At most one ACTIVE row can exist per session (enforced by a partial unique
     * index), so this is the code that resend re-dispatches.
     */
    Optional<OtpIssue> findBySessionIdAndStatus(UUID sessionId, OtpStatus status);

    long countBySessionId(UUID sessionId);
}
