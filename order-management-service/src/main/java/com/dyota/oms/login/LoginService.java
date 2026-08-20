package com.dyota.oms.login;

import com.dyota.oms.authclient.AuthServiceClient;
import com.dyota.oms.authclient.OtpResendResult;
import com.dyota.oms.authclient.OtpSendResult;
import com.dyota.oms.authclient.OtpVerifyResult;
import com.dyota.oms.support.IdentifierType;
import com.dyota.oms.support.Identifiers;
import com.dyota.oms.support.LoginException;
import java.time.Clock;
import java.util.UUID;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

/**
 * Orchestrates the login flow across the verification boundary. Deliberately not
 * transactional: every method here makes an HTTP call first, and the database work is
 * delegated to {@link LoginCompleter} afterwards.
 */
@Service
public class LoginService {

    private static final Logger log = LoggerFactory.getLogger(LoginService.class);

    private final AuthServiceClient authService;
    private final LoginCompleter completer;
    private final Clock clock;

    public LoginService(AuthServiceClient authService, LoginCompleter completer, Clock clock) {
        this.authService = authService;
        this.completer = completer;
        this.clock = clock;
    }

    public LoginStarted start(String rawIdentifier, IdentifierType type, String clientIp) {
        String identifier = Identifiers.normalise(rawIdentifier, type);
        if (!Identifiers.isValid(identifier, type)) {
            throw LoginException.badRequest("INVALID_IDENTIFIER",
                    "Identifier is not a valid " + type);
        }
        OtpSendResult sent = authService.sendOtp(identifier, type, clientIp);
        log.info("Login started for {} (session {})", Identifiers.mask(identifier), sent.sessionId());
        return new LoginStarted(sent.sessionId(), sent.otpExpiresAt(),
                sent.resendAvailableAt(), sent.sendsRemaining());
    }

    public OtpResendResult resend(UUID sessionId, String clientIp) {
        return authService.resendOtp(sessionId, clientIp);
    }

    public LoginOutcome verify(UUID sessionId, String code, String deviceLabel) {
        OtpVerifyResult result = authService.verifyOtp(sessionId, code);
        if (!result.verified() || !result.canLogin()) {
            return LoginOutcome.rejected(
                    result.reason() == null ? "VERIFICATION_FAILED" : result.reason(),
                    result.attemptsRemaining());
        }

        // authentication-service holds no user records, so the identifier it returns is
        // the only thing that crosses the boundary. Everything below is this service's.
        LoginOutcome outcome = completer.complete(
                result.identifier(), result.identifierType(), deviceLabel, clock.instant());
        log.info("Login completed for user {} (newUser={})",
                outcome.user().getId(), outcome.newUser());
        return outcome;
    }
}
