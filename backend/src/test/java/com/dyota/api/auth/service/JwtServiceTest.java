package com.dyota.api.auth.service;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

import com.dyota.api.auth.domain.User;
import com.dyota.api.config.AppProperties;
import io.jsonwebtoken.security.SignatureException;
import java.time.Duration;
import java.time.Instant;
import java.util.UUID;
import org.junit.jupiter.api.Test;

class JwtServiceTest {

    private static final String SECRET = "0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef";

    @Test
    void issueAndParseRoundtrip() {
        JwtService service = new JwtService(props(SECRET, Duration.ofMinutes(15)));
        User user = userWith("u@x.com", true);

        String token = service.issueAccessToken(user);
        JwtService.ParsedAccess parsed = service.parseAccessToken(token);

        assertThat(parsed.userId()).isEqualTo(user.getId());
        assertThat(parsed.email()).isEqualTo("u@x.com");
        assertThat(parsed.emailVerified()).isTrue();
    }

    @Test
    void parseRejectsTokenSignedWithDifferentSecret() {
        JwtService issuer = new JwtService(
                props("a".repeat(64), Duration.ofMinutes(15)));
        JwtService verifier = new JwtService(
                props("b".repeat(64), Duration.ofMinutes(15)));
        String token = issuer.issueAccessToken(userWith("u@x.com", false));

        assertThatThrownBy(() -> verifier.parseAccessToken(token)).isInstanceOf(SignatureException.class);
    }

    @Test
    void rejectsSecretShorterThan256Bits() {
        assertThatThrownBy(() -> new JwtService(props("short", Duration.ofMinutes(15))))
                .isInstanceOf(IllegalStateException.class);
    }

    private static User userWith(String email, boolean verified) {
        User u = new User();
        u.setId(UUID.randomUUID());
        u.setEmail(email);
        if (verified) {
            u.setEmailVerifiedAt(Instant.now());
        }
        return u;
    }

    private static AppProperties props(String secret, Duration accessTtl) {
        return new AppProperties(
                new AppProperties.Jwt(secret, accessTtl, Duration.ofDays(30)),
                new AppProperties.Email("no@x", Duration.ofHours(24), Duration.ofMinutes(30), "http://x"),
                new AppProperties.Oauth(new AppProperties.Oauth.Google("aud")),
                new AppProperties.Cors("http://localhost:3000"));
    }
}
