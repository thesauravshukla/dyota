package com.dyota.api.config;

import java.time.Duration;
import org.springframework.boot.context.properties.ConfigurationProperties;

@ConfigurationProperties(prefix = "dyota")
public record AppProperties(Jwt jwt, Email email, Oauth oauth, Cors cors) {

    public record Jwt(String secret, Duration accessTtl, Duration refreshTtl) {}

    public record Email(String from, Duration verificationTtl, Duration resetTtl, String baseUrl) {}

    public record Oauth(Google google) {
        public record Google(String audience) {}
    }

    public record Cors(String allowedOrigins) {}
}
