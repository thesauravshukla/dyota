package com.dyota.oms.config;

import java.time.Duration;
import java.util.List;
import org.springframework.boot.context.properties.ConfigurationProperties;

@ConfigurationProperties(prefix = "oms")
public class ServiceProperties {

    private final Cors cors = new Cors();
    private final AuthService authService = new AuthService();
    private final Session session = new Session();

    public Cors getCors() {
        return cors;
    }

    public AuthService getAuthService() {
        return authService;
    }

    public Session getSession() {
        return session;
    }

    public static class Cors {
        private List<String> allowedOrigins = List.of();

        public List<String> getAllowedOrigins() {
            return allowedOrigins;
        }

        public void setAllowedOrigins(List<String> allowedOrigins) {
            this.allowedOrigins = allowedOrigins;
        }
    }

    public static class AuthService {
        private String baseUrl = "http://localhost:8081";
        /** Must match authentication-service's auth.service-api-key. */
        private String apiKey = "";
        private Duration connectTimeout = Duration.ofSeconds(2);
        private Duration readTimeout = Duration.ofSeconds(5);

        public String getBaseUrl() {
            return baseUrl;
        }

        public void setBaseUrl(String baseUrl) {
            this.baseUrl = baseUrl;
        }

        public String getApiKey() {
            return apiKey;
        }

        public void setApiKey(String apiKey) {
            this.apiKey = apiKey;
        }

        public Duration getConnectTimeout() {
            return connectTimeout;
        }

        public void setConnectTimeout(Duration connectTimeout) {
            this.connectTimeout = connectTimeout;
        }

        public Duration getReadTimeout() {
            return readTimeout;
        }

        public void setReadTimeout(Duration readTimeout) {
            this.readTimeout = readTimeout;
        }
    }

    public static class Session {
        /** Null means tokens never expire on their own; a session ends at logout. */
        private Duration ttl;
        /** How long a revoked (logged-out) session row is kept before being swept. */
        private Duration revokedRetention = Duration.ofDays(30);
        /** Oldest active sessions beyond this count are revoked on new login. */
        private int maxPerUser = 10;
        /** last_used_at is rewritten only once it is at least this stale. */
        private Duration lastUsedPrecision = Duration.ofMinutes(5);
        private Duration cleanupInterval = Duration.ofHours(1);

        public Duration getTtl() {
            return ttl;
        }

        public void setTtl(Duration ttl) {
            this.ttl = ttl;
        }

        public Duration getRevokedRetention() {
            return revokedRetention;
        }

        public void setRevokedRetention(Duration revokedRetention) {
            this.revokedRetention = revokedRetention;
        }

        public int getMaxPerUser() {
            return maxPerUser;
        }

        public void setMaxPerUser(int maxPerUser) {
            this.maxPerUser = maxPerUser;
        }

        public Duration getLastUsedPrecision() {
            return lastUsedPrecision;
        }

        public void setLastUsedPrecision(Duration lastUsedPrecision) {
            this.lastUsedPrecision = lastUsedPrecision;
        }

        public Duration getCleanupInterval() {
            return cleanupInterval;
        }

        public void setCleanupInterval(Duration cleanupInterval) {
            this.cleanupInterval = cleanupInterval;
        }
    }
}
