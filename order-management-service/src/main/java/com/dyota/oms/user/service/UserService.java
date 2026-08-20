package com.dyota.oms.user.service;

import com.dyota.oms.support.IdentifierType;
import com.dyota.oms.support.Identifiers;
import com.dyota.oms.support.LoginException;
import com.dyota.oms.user.domain.AppUser;
import com.dyota.oms.user.repository.AppUserRepository;
import java.time.Instant;
import java.util.Optional;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class UserService {

    private static final Logger log = LoggerFactory.getLogger(UserService.class);

    private final AppUserRepository users;

    public UserService(AppUserRepository users) {
        this.users = users;
    }

    /**
     * Login and signup are the same operation in a passwordless design: a verified
     * identifier with no account behind it simply becomes one.
     */
    @Transactional
    public Resolved findOrCreate(String identifier, IdentifierType type, Instant now) {
        Optional<AppUser> existing = lookup(identifier, type);
        if (existing.isPresent()) {
            AppUser user = existing.get();
            requireLoginAllowed(user);
            user.recordLogin(type, now);
            return new Resolved(user, false);
        }

        AppUser created = AppUser.createVerified(identifier, type, now);
        created.recordLogin(type, now);
        try {
            users.saveAndFlush(created);
        } catch (DataIntegrityViolationException e) {
            // Two first-time logins for the same identifier can race here; the unique
            // constraint decides, and the loser reads back the winner's row.
            AppUser winner = lookup(identifier, type).orElseThrow(() -> e);
            requireLoginAllowed(winner);
            winner.recordLogin(type, now);
            return new Resolved(winner, false);
        }
        log.info("Created account for {}", Identifiers.mask(identifier));
        return new Resolved(created, true);
    }

    private Optional<AppUser> lookup(String identifier, IdentifierType type) {
        return type == IdentifierType.PHONE
                ? users.findByPhone(identifier)
                : users.findByEmail(identifier);
    }

    private static void requireLoginAllowed(AppUser user) {
        if (!user.getStatus().canLogIn()) {
            throw LoginException.forbidden("ACCOUNT_" + user.getStatus().name(),
                    "This account cannot sign in");
        }
    }

    public record Resolved(AppUser user, boolean created) {
    }
}
