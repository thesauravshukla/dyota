package com.dyota.auth.support;

import java.time.Duration;
import org.springframework.http.HttpStatus;

/**
 * Carries the HTTP status and a stable machine-readable code, so the login API can
 * branch on {@code code} rather than parsing prose.
 */
public class AuthServiceException extends RuntimeException {

    private final String code;
    private final HttpStatus status;
    private final Duration retryAfter;

    public AuthServiceException(String code, HttpStatus status, String message) {
        this(code, status, message, null);
    }

    public AuthServiceException(String code, HttpStatus status, String message, Duration retryAfter) {
        super(message);
        this.code = code;
        this.status = status;
        this.retryAfter = retryAfter;
    }

    public static AuthServiceException notFound() {
        return new AuthServiceException("SESSION_NOT_FOUND", HttpStatus.NOT_FOUND,
                "No such verification session");
    }

    public static AuthServiceException badRequest(String code, String message) {
        return new AuthServiceException(code, HttpStatus.BAD_REQUEST, message);
    }

    public static AuthServiceException tooManyRequests(String code, String message, Duration retryAfter) {
        return new AuthServiceException(code, HttpStatus.TOO_MANY_REQUESTS, message, retryAfter);
    }

    public static AuthServiceException conflict(String code, String message) {
        return new AuthServiceException(code, HttpStatus.CONFLICT, message);
    }

    public String getCode() {
        return code;
    }

    public HttpStatus getStatus() {
        return status;
    }

    public Duration getRetryAfter() {
        return retryAfter;
    }
}
