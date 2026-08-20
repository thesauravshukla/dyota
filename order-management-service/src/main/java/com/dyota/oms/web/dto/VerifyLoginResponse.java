package com.dyota.oms.web.dto;

import com.dyota.oms.login.LoginOutcome;

/**
 * A wrong code comes back 200 with {@code authenticated: false}, so the client branches
 * on the body rather than on transport errors.
 */
public record VerifyLoginResponse(
        boolean authenticated,
        String reason,
        Integer attemptsRemaining,
        String token,
        String tokenType,
        Boolean isNewUser,
        UserDto user) {

    public static VerifyLoginResponse from(LoginOutcome outcome) {
        if (!outcome.authenticated()) {
            return new VerifyLoginResponse(false, outcome.reason(), outcome.attemptsRemaining(),
                    null, null, null, null);
        }
        return new VerifyLoginResponse(true, null, null, outcome.token(), "Bearer",
                outcome.newUser(), UserDto.from(outcome.user()));
    }
}
