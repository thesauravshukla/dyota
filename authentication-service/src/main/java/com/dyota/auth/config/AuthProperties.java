package com.dyota.auth.config;

import java.time.Duration;
import org.springframework.boot.context.properties.ConfigurationProperties;

/**
 * Every service-level knob lives here, so cooldowns and attempt caps are changed by
 * configuration per environment rather than by a code change.
 */
@ConfigurationProperties(prefix = "auth")
public class AuthProperties {

    /** Shared secret the login API must present. Blank disables the check (dev only). */
    private String serviceApiKey = "";

    private final Otp otp = new Otp();
    private final Session session = new Session();
    private final RateLimit rateLimit = new RateLimit();

    public String getServiceApiKey() {
        return serviceApiKey;
    }

    public void setServiceApiKey(String serviceApiKey) {
        this.serviceApiKey = serviceApiKey;
    }

    public Otp getOtp() {
        return otp;
    }

    public Session getSession() {
        return session;
    }

    public RateLimit getRateLimit() {
        return rateLimit;
    }

    public static class Otp {
        /** Number of digits in a generated code. */
        private int length = 6;
        /** How long a code stays valid, measured from first issue. */
        private Duration ttl = Duration.ofMinutes(5);
        /** Minimum gap between two dispatches on the same session. */
        private Duration resendCooldown = Duration.ofSeconds(30);
        /** Total dispatches allowed per session, including the initial send. */
        private int maxSendsPerSession = 3;
        /** Wrong-code submissions allowed before the session locks. */
        private int maxVerifyAttempts = 5;
        /**
         * When false, resending does not push out the code's expiry, so total code
         * lifetime stays bounded no matter how many times it is resent.
         */
        private boolean extendTtlOnResend = false;
        /** Which OtpSender to use: logging | real. */
        private String sender = "logging";
        /**
         * No SMS provider is wired yet. While this is false the service reports the
         * phone channel as unavailable up front instead of accepting a login it cannot
         * possibly deliver.
         */
        private boolean smsEnabled = false;
        private String mailFrom = "no-reply@dyota.local";

        public int getLength() {
            return length;
        }

        public void setLength(int length) {
            this.length = length;
        }

        public Duration getTtl() {
            return ttl;
        }

        public void setTtl(Duration ttl) {
            this.ttl = ttl;
        }

        public Duration getResendCooldown() {
            return resendCooldown;
        }

        public void setResendCooldown(Duration resendCooldown) {
            this.resendCooldown = resendCooldown;
        }

        public int getMaxSendsPerSession() {
            return maxSendsPerSession;
        }

        public void setMaxSendsPerSession(int maxSendsPerSession) {
            this.maxSendsPerSession = maxSendsPerSession;
        }

        public int getMaxVerifyAttempts() {
            return maxVerifyAttempts;
        }

        public void setMaxVerifyAttempts(int maxVerifyAttempts) {
            this.maxVerifyAttempts = maxVerifyAttempts;
        }

        public boolean isExtendTtlOnResend() {
            return extendTtlOnResend;
        }

        public void setExtendTtlOnResend(boolean extendTtlOnResend) {
            this.extendTtlOnResend = extendTtlOnResend;
        }

        public boolean isSmsEnabled() {
            return smsEnabled;
        }

        public void setSmsEnabled(boolean smsEnabled) {
            this.smsEnabled = smsEnabled;
        }

        public String getSender() {
            return sender;
        }

        public void setSender(String sender) {
            this.sender = sender;
        }

        public String getMailFrom() {
            return mailFrom;
        }

        public void setMailFrom(String mailFrom) {
            this.mailFrom = mailFrom;
        }
    }

    public static class Session {
        /** How long a session may stay open before it is abandoned. */
        private Duration ttl = Duration.ofMinutes(15);
        /**
         * Grace window after termination before the row is deleted, so a retried
         * request gets a meaningful answer instead of "not found". Zero deletes at once.
         */
        private Duration postTerminalRetention = Duration.ofSeconds(60);
        private Duration cleanupInterval = Duration.ofMinutes(5);
        private int cleanupBatchSize = 500;

        public Duration getTtl() {
            return ttl;
        }

        public void setTtl(Duration ttl) {
            this.ttl = ttl;
        }

        public Duration getPostTerminalRetention() {
            return postTerminalRetention;
        }

        public void setPostTerminalRetention(Duration postTerminalRetention) {
            this.postTerminalRetention = postTerminalRetention;
        }

        public Duration getCleanupInterval() {
            return cleanupInterval;
        }

        public void setCleanupInterval(Duration cleanupInterval) {
            this.cleanupInterval = cleanupInterval;
        }

        public int getCleanupBatchSize() {
            return cleanupBatchSize;
        }

        public void setCleanupBatchSize(int cleanupBatchSize) {
            this.cleanupBatchSize = cleanupBatchSize;
        }
    }

    public static class RateLimit {
        private boolean enabled = true;
        /** Fixed window length for both caps below. */
        private Duration window = Duration.ofHours(1);
        /** Sends allowed per identifier per window, across all sessions. */
        private int perIdentifierSends = 5;
        /** Sends allowed per client IP per window, across all sessions. */
        private int perIpSends = 20;

        public boolean isEnabled() {
            return enabled;
        }

        public void setEnabled(boolean enabled) {
            this.enabled = enabled;
        }

        public Duration getWindow() {
            return window;
        }

        public void setWindow(Duration window) {
            this.window = window;
        }

        public int getPerIdentifierSends() {
            return perIdentifierSends;
        }

        public void setPerIdentifierSends(int perIdentifierSends) {
            this.perIdentifierSends = perIdentifierSends;
        }

        public int getPerIpSends() {
            return perIpSends;
        }

        public void setPerIpSends(int perIpSends) {
            this.perIpSends = perIpSends;
        }
    }
}
