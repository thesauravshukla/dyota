package com.dyota.auth.otp.delivery;

import com.dyota.auth.config.AuthProperties;
import com.dyota.auth.session.domain.IdentifierType;
import com.dyota.auth.session.domain.Purpose;
import com.dyota.auth.support.Identifiers;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.stereotype.Component;

/**
 * Placeholder for the SMS provider.
 *
 * <p>Until one is wired, {@link #supports} returns false so the phone channel is reported
 * as unavailable before a session is ever created. Claiming the channel and then failing
 * at delivery would hand the caller a session id for a code that is never sent.
 */
@Component
@ConditionalOnProperty(name = "auth.otp.sender", havingValue = "real")
public class SmsOtpSender implements OtpSender {

    private static final Logger log = LoggerFactory.getLogger(SmsOtpSender.class);

    private final AuthProperties properties;

    public SmsOtpSender(AuthProperties properties) {
        this.properties = properties;
    }

    @Override
    public boolean supports(IdentifierType type) {
        return type == IdentifierType.PHONE && properties.getOtp().isSmsEnabled();
    }

    @Override
    public void send(String identifier, IdentifierType type, String code, Purpose purpose) {
        // TODO: wire a provider (Twilio / MSG91) once DLT registration completes.
        log.error("No SMS provider configured; cannot deliver {} code to {}",
                purpose, Identifiers.mask(identifier));
        throw new UnsupportedOperationException("SMS delivery is not configured");
    }
}
