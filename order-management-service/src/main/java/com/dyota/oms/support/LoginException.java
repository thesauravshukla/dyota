package com.dyota.oms.support;

import java.time.Duration;
import org.springframework.http.HttpStatus;

public class LoginException extends RuntimeException {

    private final String code;
    private final HttpStatus status;
    private final Duration retryAfter;

    public LoginException(String code, HttpStatus status, String message) {
        this(code, status, message, null);
    }

    public LoginException(String code, HttpStatus status, String message, Duration retryAfter) {
        super(message);
        this.code = code;
        this.status = status;
        this.retryAfter = retryAfter;
    }

    public static LoginException unauthorized(String code, String message) {
        return new LoginException(code, HttpStatus.UNAUTHORIZED, message);
    }

    public static LoginException forbidden(String code, String message) {
        return new LoginException(code, HttpStatus.FORBIDDEN, message);
    }

    public static LoginException badRequest(String code, String message) {
        return new LoginException(code, HttpStatus.BAD_REQUEST, message);
    }

    public static LoginException upstreamUnavailable() {
        return new LoginException("VERIFICATION_UNAVAILABLE", HttpStatus.SERVICE_UNAVAILABLE,
                "Verification service is unavailable");
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
