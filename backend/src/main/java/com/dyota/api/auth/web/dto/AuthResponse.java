package com.dyota.api.auth.web.dto;

import com.dyota.api.auth.service.AuthResult;

public record AuthResponse(
        String accessToken, String refreshToken, long expiresIn, String tokenType, UserDto user) {

    public static AuthResponse from(AuthResult result) {
        return new AuthResponse(
                result.accessToken(),
                result.refreshToken(),
                result.expiresInSeconds(),
                "Bearer",
                UserDto.from(result.user()));
    }
}
