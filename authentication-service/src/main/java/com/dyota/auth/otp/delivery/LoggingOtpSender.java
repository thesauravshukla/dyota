package com.dyota.auth.otp.delivery;

import com.dyota.auth.session.domain.IdentifierType;
import com.dyota.auth.session.domain.Purpose;
import com.dyota.auth.support.Identifiers;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.stereotype.Component;

/**
 * Development sender: prints the code so the whole flow is exercisable with no SMTP
 * or SMS provider. This is the ONLY place a code is ever logged, and it is gated
 * behind an explicit non-default configuration value.
 */
@Component
@ConditionalOnProperty(name = "auth.otp.sender", havingValue = "logging", matchIfMissing = true)
public class LoggingOtpSender implements OtpSender {

    private static final Logger log = LoggerFactory.getLogger(LoggingOtpSender.class);

    @Override
    public boolean supports(IdentifierType type) {
        return true;
    }

    @Override
    public void send(String identifier, IdentifierType type, String code, Purpose purpose) {
        log.warn("[DEV SENDER] {} code for {} ({}): {}",
                purpose, Identifiers.mask(identifier), type, code);
    }
}
