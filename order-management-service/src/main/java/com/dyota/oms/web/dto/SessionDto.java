package com.dyota.oms.web.dto;

import com.dyota.oms.session.domain.UserSession;
import java.time.Instant;
import java.util.UUID;

/** Never exposes the token or its digest. */
public record SessionDto(
        UUID id,
        String deviceLabel,
        Instant createdAt,
        Instant lastUsedAt,
        boolean current) {

    public static SessionDto from(UserSession s, UUID currentSessionId) {
        return new SessionDto(s.getId(), s.getDeviceLabel(), s.getCreatedAt(),
                s.getLastUsedAt(), s.getId().equals(currentSessionId));
    }
}
