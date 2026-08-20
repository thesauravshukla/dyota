package com.dyota.auth.web.dto;

/** Stable machine-readable code plus a human message. */
public record ApiError(String code, String message, Long retryAfterSeconds) {

    public static ApiError of(String code, String message) {
        return new ApiError(code, message, null);
    }
}
