package com.dyota.oms.login;

import com.dyota.oms.session.service.SessionService;
import com.dyota.oms.support.IdentifierType;
import com.dyota.oms.user.service.UserService;
import java.time.Instant;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

/**
 * The database half of a successful verification, kept in its own bean so that the
 * transaction starts only after the call to authentication-service has returned.
 * Wrapping the HTTP call in the transaction would hold a connection open for the
 * duration of a network round trip.
 */
@Component
public class LoginCompleter {

    private final UserService users;
    private final SessionService sessions;

    public LoginCompleter(UserService users, SessionService sessions) {
        this.users = users;
        this.sessions = sessions;
    }

    @Transactional
    public LoginOutcome complete(
            String identifier, IdentifierType type, String deviceLabel, Instant now) {
        UserService.Resolved resolved = users.findOrCreate(identifier, type, now);
        SessionService.Issued issued = sessions.open(resolved.user().getId(), deviceLabel, now);
        return LoginOutcome.success(issued.token(), resolved.user(), resolved.created());
    }
}
