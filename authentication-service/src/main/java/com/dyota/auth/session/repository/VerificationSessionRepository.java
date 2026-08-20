package com.dyota.auth.session.repository;

import com.dyota.auth.session.domain.VerificationSession;
import jakarta.persistence.LockModeType;
import java.time.Instant;
import java.util.Optional;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Lock;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface VerificationSessionRepository extends JpaRepository<VerificationSession, UUID> {

    /**
     * Row-level lock for resend and verify. The cooldown check and the counter
     * increment have to be one atomic unit, otherwise two simultaneous taps both
     * observe the pre-increment state and both pass.
     */
    @Lock(LockModeType.PESSIMISTIC_WRITE)
    @Query("select s from VerificationSession s where s.id = :id")
    Optional<VerificationSession> findByIdForUpdate(@Param("id") UUID id);

    /**
     * Batched sweep. Postgres has no LIMIT on DELETE, hence the id subquery; batching
     * keeps each transaction short so cleanup never blocks live traffic.
     * Cascades to otp_issue.
     */
    @Modifying
    @Query(value = """
            DELETE FROM verification_session
            WHERE id IN (
                SELECT id FROM verification_session
                WHERE expires_at < :now
                   OR (terminated_at IS NOT NULL AND terminated_at < :terminatedBefore)
                LIMIT :batchSize
            )
            """, nativeQuery = true)
    int deleteFinishedBatch(
            @Param("now") Instant now,
            @Param("terminatedBefore") Instant terminatedBefore,
            @Param("batchSize") int batchSize);
}
