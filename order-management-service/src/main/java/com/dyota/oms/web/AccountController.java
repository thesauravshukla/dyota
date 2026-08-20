package com.dyota.oms.web;

import com.dyota.oms.config.AuthenticatedUser;
import com.dyota.oms.session.service.SessionService;
import com.dyota.oms.support.LoginException;
import com.dyota.oms.user.repository.AppUserRepository;
import com.dyota.oms.web.dto.SessionDto;
import com.dyota.oms.web.dto.UserDto;
import java.time.Clock;
import java.util.List;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/** Everything here requires a valid bearer token; the filter enforces that. */
@RestController
@RequestMapping("/api/v1/auth")
public class AccountController {

    private final AppUserRepository users;
    private final SessionService sessions;
    private final Clock clock;

    public AccountController(
            AppUserRepository users, SessionService sessions, Clock clock) {
        this.users = users;
        this.sessions = sessions;
        this.clock = clock;
    }

    @GetMapping("/me")
    public UserDto me(AuthenticatedUser principal) {
        return users.findById(principal.userId())
                .map(UserDto::from)
                .orElseThrow(() -> new LoginException("USER_NOT_FOUND",
                        HttpStatus.NOT_FOUND, "Account no longer exists"));
    }

    /**
     * With tokens that never expire on their own, being able to see and end sessions is
     * the user's only lever if a device is lost.
     */
    @GetMapping("/sessions")
    public List<SessionDto> sessions(AuthenticatedUser principal) {
        return sessions.activeSessions(principal.userId()).stream()
                .map(s -> SessionDto.from(s, principal.sessionId()))
                .toList();
    }

    @PostMapping("/logout")
    public ResponseEntity<Void> logout(AuthenticatedUser principal) {
        sessions.revoke(principal.token(), clock.instant());
        return ResponseEntity.noContent().build();
    }

    @PostMapping("/logout/all")
    public ResponseEntity<Void> logoutAll(AuthenticatedUser principal) {
        sessions.revokeAll(principal.userId(), clock.instant());
        return ResponseEntity.noContent().build();
    }
}
