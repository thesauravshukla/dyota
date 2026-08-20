package com.dyota.oms.login;

import com.dyota.oms.user.domain.AppUser;

/**
 * A wrong code is a normal outcome rather than an error, so it is reported here and
 * surfaced to the client as a 200 with {@code authenticated: false}.
 */
public record LoginOutcome(
        boolean authenticated,
        String reason,
        Integer attemptsRemaining,
        String token,
        AppUser user,
        boolean newUser) {

    public static LoginOutcome success(String token, AppUser user, boolean newUser) {
        return new LoginOutcome(true, null, null, token, user, newUser);
    }

    public static LoginOutcome rejected(String reason, Integer attemptsRemaining) {
        return new LoginOutcome(false, reason, attemptsRemaining, null, null, false);
    }
}
