package com.dyota.oms.authclient;

import com.dyota.oms.config.ServiceProperties;
import com.dyota.oms.support.IdentifierType;
import com.dyota.oms.support.LoginException;
import java.time.Duration;
import java.util.Map;
import java.util.UUID;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.web.client.ClientHttpRequestFactories;
import org.springframework.boot.web.client.ClientHttpRequestFactorySettings;
import org.springframework.http.HttpStatus;
import org.springframework.http.HttpStatusCode;
import org.springframework.stereotype.Component;
import org.springframework.web.client.ResourceAccessException;
import org.springframework.web.client.RestClient;

@Component
public class HttpAuthServiceClient implements AuthServiceClient {

    private static final Logger log = LoggerFactory.getLogger(HttpAuthServiceClient.class);

    private final RestClient client;

    public HttpAuthServiceClient(ServiceProperties properties, RestClient.Builder builder) {
        ServiceProperties.AuthService cfg = properties.getAuthService();
        this.client = builder
                .baseUrl(cfg.getBaseUrl())
                .requestFactory(ClientHttpRequestFactories.get(
                        ClientHttpRequestFactorySettings.DEFAULTS
                                .withConnectTimeout(cfg.getConnectTimeout())
                                .withReadTimeout(cfg.getReadTimeout())))
                .defaultHeaders(h -> {
                    if (!cfg.getApiKey().isBlank()) {
                        h.set("X-Service-Key", cfg.getApiKey());
                    }
                })
                .build();
    }

    @Override
    public OtpSendResult sendOtp(String identifier, IdentifierType type, String clientIp) {
        return post("/api/v1/otp/send", clientIp, OtpSendResult.class, Map.of(
                "identifier", identifier,
                "identifierType", type.name(),
                "purpose", "LOGIN"));
    }

    @Override
    public OtpResendResult resendOtp(UUID sessionId, String clientIp) {
        return post("/api/v1/otp/resend", clientIp, OtpResendResult.class, Map.of(
                "sessionId", sessionId.toString()));
    }

    @Override
    public OtpVerifyResult verifyOtp(UUID sessionId, String code) {
        return post("/api/v1/verify", null, OtpVerifyResult.class, Map.of(
                "sessionId", sessionId.toString(),
                "code", code));
    }

    private <T> T post(String path, String clientIp, Class<T> type, Map<String, String> body) {
        try {
            return client.post()
                    .uri(path)
                    .headers(h -> {
                        // Without this, authentication-service sees this service's address
                        // for every caller and its per-IP send cap would throttle everyone
                        // globally instead of the actual abuser.
                        if (clientIp != null && !clientIp.isBlank()) {
                            h.set("X-Forwarded-For", clientIp);
                        }
                    })
                    .body(body)
                    .retrieve()
                    .onStatus(HttpStatusCode::isError, (req, res) -> {
                        throw translate(res.getStatusCode(), readError(res));
                    })
                    .body(type);
        } catch (ResourceAccessException e) {
            // Connection refused or timed out: the caller gets a clean 503 rather than
            // a stack trace, and can retry.
            log.error("authentication-service unreachable calling {}: {}", path, e.getMessage());
            throw LoginException.upstreamUnavailable();
        }
    }

    private static UpstreamError readError(org.springframework.http.client.ClientHttpResponse res) {
        try {
            String raw = new String(res.getBody().readAllBytes());
            String code = extract(raw, "code");
            String message = extract(raw, "message");
            String retry = extract(raw, "retryAfterSeconds");
            return new UpstreamError(code, message, retry);
        } catch (Exception e) {
            return new UpstreamError(null, null, null);
        }
    }

    /** Minimal extraction so an unparseable upstream body can never mask the real status. */
    private static String extract(String json, String field) {
        var m = java.util.regex.Pattern
                .compile("\"" + field + "\"\\s*:\\s*(?:\"([^\"]*)\"|([0-9]+))")
                .matcher(json);
        return m.find() ? (m.group(1) != null ? m.group(1) : m.group(2)) : null;
    }

    /**
     * Upstream codes are passed straight through rather than flattened, so the client can
     * tell "wait 20 seconds" apart from "you are out of attempts, start again".
     */
    private static LoginException translate(HttpStatusCode status, UpstreamError error) {
        String code = error.code() == null ? "VERIFICATION_FAILED" : error.code();
        String message = error.message() == null ? "Verification request failed" : error.message();

        // A structured error body means the service is alive and telling us something
        // specific, so the code is preserved even on a 5xx. Flattening it would leave the
        // client unable to tell "this channel is not supported" from "try again shortly".
        if (status.is5xxServerError() && error.code() == null) {
            log.error("authentication-service returned {} with no error code", status);
            return LoginException.upstreamUnavailable();
        }
        if (status.is5xxServerError()) {
            log.warn("authentication-service returned {} ({})", status, code);
        }
        Duration retryAfter = null;
        if (error.retryAfterSeconds() != null) {
            try {
                retryAfter = Duration.ofSeconds(Long.parseLong(error.retryAfterSeconds()));
            } catch (NumberFormatException ignored) {
                // absent or malformed Retry-After simply means we do not surface one
            }
        }
        HttpStatus mapped = HttpStatus.resolve(status.value());
        return new LoginException(code, mapped == null ? HttpStatus.BAD_GATEWAY : mapped,
                message, retryAfter);
    }

    private record UpstreamError(String code, String message, String retryAfterSeconds) {
    }
}
