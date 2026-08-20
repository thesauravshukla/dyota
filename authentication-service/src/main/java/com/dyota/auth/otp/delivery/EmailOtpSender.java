package com.dyota.auth.otp.delivery;

import com.dyota.auth.config.AuthProperties;
import com.dyota.auth.session.domain.IdentifierType;
import com.dyota.auth.session.domain.Purpose;
import com.dyota.auth.support.Identifiers;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Component;

@Component
@ConditionalOnProperty(name = "auth.otp.sender", havingValue = "real")
public class EmailOtpSender implements OtpSender {

    private static final Logger log = LoggerFactory.getLogger(EmailOtpSender.class);

    private final JavaMailSender mailSender;
    private final AuthProperties properties;

    public EmailOtpSender(JavaMailSender mailSender, AuthProperties properties) {
        this.mailSender = mailSender;
        this.properties = properties;
    }

    @Override
    public boolean supports(IdentifierType type) {
        return type == IdentifierType.EMAIL;
    }

    @Override
    public void send(String identifier, IdentifierType type, String code, Purpose purpose) {
        SimpleMailMessage message = new SimpleMailMessage();
        message.setFrom(properties.getOtp().getMailFrom());
        message.setTo(identifier);
        message.setSubject("Your verification code");
        message.setText("Your verification code is " + code
                + ". It expires in " + properties.getOtp().getTtl().toMinutes() + " minutes."
                + " If you did not request this, ignore this email.");
        mailSender.send(message);
        log.info("Dispatched {} code by email to {}", purpose, Identifiers.mask(identifier));
    }
}
