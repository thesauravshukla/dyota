package com.dyota.api.auth.email;

import com.dyota.api.config.AppProperties;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

@Service
public class EmailService {

    private static final Logger log = LoggerFactory.getLogger(EmailService.class);

    private final JavaMailSender mailSender;
    private final AppProperties props;

    public EmailService(JavaMailSender mailSender, AppProperties props) {
        this.mailSender = mailSender;
        this.props = props;
    }

    public void sendVerificationEmail(String to, String rawToken) {
        String link = props.email().baseUrl() + "/verify-email?token=" + rawToken;
        send(to, "Verify your Dyota email",
                "Welcome to Dyota.\n\n"
                        + "Click the link below to verify your email address:\n"
                        + link + "\n\n"
                        + "This link expires in "
                        + props.email().verificationTtl().toHours() + " hours.\n\n"
                        + "If you didn't create an account, you can ignore this email.");
    }

    public void sendPasswordResetEmail(String to, String rawToken) {
        String link = props.email().baseUrl() + "/reset-password?token=" + rawToken;
        send(to, "Reset your Dyota password",
                "We received a request to reset your password.\n\n"
                        + "Click the link below to choose a new password:\n"
                        + link + "\n\n"
                        + "This link expires in "
                        + props.email().resetTtl().toMinutes() + " minutes.\n\n"
                        + "If you didn't request this, you can ignore this email.");
    }

    private void send(String to, String subject, String body) {
        SimpleMailMessage message = new SimpleMailMessage();
        message.setFrom(props.email().from());
        message.setTo(to);
        message.setSubject(subject);
        message.setText(body);
        try {
            mailSender.send(message);
        } catch (Exception e) {
            log.warn("Failed to send email to {}: {}", to, e.getMessage());
        }
    }
}
