package com.dyota.oms.config;

import com.dyota.oms.support.LoginException;
import com.dyota.oms.web.dto.ApiError;
import java.util.stream.Collectors;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.http.converter.HttpMessageNotReadableException;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

@RestControllerAdvice
public class GlobalExceptionHandler {

    private static final Logger log = LoggerFactory.getLogger(GlobalExceptionHandler.class);

    @ExceptionHandler(LoginException.class)
    public ResponseEntity<ApiError> handleLogin(LoginException e) {
        Long retryAfter = e.getRetryAfter() == null
                ? null
                : Math.max(1, e.getRetryAfter().toSeconds());

        ResponseEntity.BodyBuilder builder = ResponseEntity.status(e.getStatus());
        if (retryAfter != null) {
            builder.header(HttpHeaders.RETRY_AFTER, String.valueOf(retryAfter));
        }
        return builder.body(new ApiError(e.getCode(), e.getMessage(), retryAfter));
    }

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<ApiError> handleValidation(MethodArgumentNotValidException e) {
        String detail = e.getBindingResult().getFieldErrors().stream()
                .map(f -> f.getField() + " " + f.getDefaultMessage())
                .collect(Collectors.joining("; "));
        return ResponseEntity.badRequest().body(ApiError.of("VALIDATION_FAILED", detail));
    }

    @ExceptionHandler(HttpMessageNotReadableException.class)
    public ResponseEntity<ApiError> handleUnreadable(HttpMessageNotReadableException e) {
        return ResponseEntity.badRequest()
                .body(ApiError.of("MALFORMED_REQUEST", "Request body could not be parsed"));
    }

    @ExceptionHandler(Exception.class)
    public ResponseEntity<ApiError> handleUnexpected(Exception e) {
        log.error("Unhandled failure", e);
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body(ApiError.of("INTERNAL_ERROR", "Unexpected error"));
    }
}
