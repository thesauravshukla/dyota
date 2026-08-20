package com.dyota.oms.web.dto;

import com.dyota.oms.user.domain.AppUser;
import java.time.Instant;
import java.util.UUID;

public record UserDto(
        UUID id,
        String phone,
        String email,
        String displayName,
        boolean phoneVerified,
        boolean emailVerified,
        Instant createdAt,
        Instant lastLoginAt) {

    public static UserDto from(AppUser u) {
        return new UserDto(u.getId(), u.getPhone(), u.getEmail(), u.getDisplayName(),
                u.isPhoneVerified(), u.isEmailVerified(), u.getCreatedAt(), u.getLastLoginAt());
    }
}
