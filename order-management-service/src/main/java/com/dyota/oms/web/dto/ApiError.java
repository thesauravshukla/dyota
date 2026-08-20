package com.dyota.oms.web.dto;

public record ApiError(String code, String message, Long retryAfterSeconds) {

    public static ApiError of(String code, String message) {
        return new ApiError(code, message, null);
    }
}
