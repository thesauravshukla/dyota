package com.dyota.api.auth.service;

import org.springframework.http.HttpStatus;

public class AuthException extends RuntimeException {

    private final HttpStatus status;
    private final String code;

    public AuthException(HttpStatus status, String code, String message) {
        super(message);
        this.status = status;
        this.code = code;
    }

    public HttpStatus getStatus() {
        return status;
    }

    public String getCode() {
        return code;
    }

    public static AuthException invalidCredentials() {
        return new AuthException(HttpStatus.UNAUTHORIZED, "INVALID_CREDENTIALS", "Invalid email or password");
    }

    public static AuthException emailExists() {
        return new AuthException(HttpStatus.CONFLICT, "EMAIL_EXISTS", "An account with that email already exists");
    }

    public static AuthException passwordMismatch() {
        return new AuthException(HttpStatus.BAD_REQUEST, "PASSWORD_MISMATCH", "Password and confirmation do not match");
    }

    public static AuthException invalidToken() {
        return new AuthException(HttpStatus.BAD_REQUEST, "TOKEN_INVALID", "The token is invalid");
    }

    public static AuthException tokenExpired() {
        return new AuthException(HttpStatus.GONE, "TOKEN_EXPIRED", "The token has expired");
    }

    public static AuthException invalidRefresh() {
        return new AuthException(HttpStatus.UNAUTHORIZED, "INVALID_REFRESH_TOKEN", "The refresh token is invalid or expired");
    }

    public static AuthException oauthFailed() {
        return new AuthException(HttpStatus.UNAUTHORIZED, "OAUTH_FAILED", "Could not verify the identity provider token");
    }

    public static AuthException notAuthenticated() {
        return new AuthException(HttpStatus.UNAUTHORIZED, "NOT_AUTHENTICATED", "Authentication is required");
    }
}
