package com.dyota.api.auth.web.dto;

import com.dyota.api.auth.domain.User;
import com.fasterxml.jackson.annotation.JsonInclude;
import java.util.UUID;

/**
 * V1 user payload. {@code name} is intentionally omitted (the column is kept
 * nullable for future flexibility but never exposed).
 */
@JsonInclude(JsonInclude.Include.NON_NULL)
public record UserDto(UUID id, String email, boolean emailVerified) {

    public static UserDto from(User user) {
        return new UserDto(user.getId(), user.getEmail(), user.isEmailVerified());
    }
}
