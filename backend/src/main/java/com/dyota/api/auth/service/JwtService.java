package com.dyota.api.auth.service;

import com.dyota.api.auth.domain.User;
import com.dyota.api.config.AppProperties;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jws;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;
import java.nio.charset.StandardCharsets;
import java.time.Instant;
import java.util.Date;
import java.util.UUID;
import javax.crypto.SecretKey;
import org.springframework.stereotype.Service;

@Service
public class JwtService {

    private static final String TYP_ACCESS = "access";

    private final SecretKey signingKey;
    private final AppProperties props;

    public JwtService(AppProperties props) {
        this.props = props;
        byte[] secret = props.jwt().secret().getBytes(StandardCharsets.UTF_8);
        if (secret.length < 32) {
            throw new IllegalStateException("dyota.jwt.secret must be >= 32 bytes (256 bits)");
        }
        this.signingKey = Keys.hmacShaKeyFor(secret);
    }

    public String issueAccessToken(User user) {
        Instant now = Instant.now();
        Instant exp = now.plus(props.jwt().accessTtl());
        return Jwts.builder()
                .subject(user.getId().toString())
                .claim("email", user.getEmail())
                .claim("email_verified", user.isEmailVerified())
                .claim("typ", TYP_ACCESS)
                .issuedAt(Date.from(now))
                .expiration(Date.from(exp))
                .signWith(signingKey)
                .compact();
    }

    public ParsedAccess parseAccessToken(String token) {
        Jws<Claims> jws = Jwts.parser()
                .verifyWith(signingKey)
                .build()
                .parseSignedClaims(token);
        Claims c = jws.getPayload();
        Object typ = c.get("typ");
        if (!TYP_ACCESS.equals(typ)) {
            throw new IllegalArgumentException("Unexpected token type");
        }
        return new ParsedAccess(
                UUID.fromString(c.getSubject()),
                c.get("email", String.class),
                Boolean.TRUE.equals(c.get("email_verified", Boolean.class)));
    }

    public record ParsedAccess(UUID userId, String email, boolean emailVerified) {}
}
