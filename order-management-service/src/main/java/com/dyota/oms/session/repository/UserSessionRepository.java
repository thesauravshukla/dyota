package com.dyota.oms.session.repository;

import com.dyota.oms.session.domain.UserSession;
import java.time.Instant;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface UserSessionRepository extends JpaRepository<UserSession, UUID> {

    /** The hot path: one indexed lookup per authenticated request. */
    Optional<UserSession> findByTokenHash(String tokenHash);

    /** Oldest first, so the per-user cap revokes the least recently opened sessions. */
    List<UserSession> findByUserIdAndRevokedAtIsNullOrderByCreatedAtAsc(UUID userId);

    @Modifying
    @Query("update UserSession s set s.revokedAt = :now "
            + "where s.userId = :userId and s.revokedAt is null")
    int revokeAllForUser(@Param("userId") UUID userId, @Param("now") Instant now);

    /** A logged-out session has no further value once the retention window passes. */
    @Modifying
    @Query("delete from UserSession s where s.revokedAt is not null and s.revokedAt < :before")
    int deleteRevokedBefore(@Param("before") Instant before);

    @Modifying
    @Query("delete from UserSession s where s.expiresAt is not null and s.expiresAt < :now")
    int deleteExpiredBefore(@Param("now") Instant now);
}
