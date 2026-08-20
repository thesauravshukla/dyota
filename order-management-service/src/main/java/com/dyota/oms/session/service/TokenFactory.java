package com.dyota.oms.session.service;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.Base64;
import org.springframework.stereotype.Component;

/**
 * Mints and digests bearer tokens.
 *
 * <p>256 bits from a CSPRNG rather than a UUID: a v4 UUID carries only 122 bits of
 * randomness and a fixed version/variant structure, which is thin for a credential that
 * never expires.
 */
@Component
public class TokenFactory {

    private static final int TOKEN_BYTES = 32;

    private final SecureRandom random = new SecureRandom();

    public String newToken() {
        byte[] bytes = new byte[TOKEN_BYTES];
        random.nextBytes(bytes);
        return Base64.getUrlEncoder().withoutPadding().encodeToString(bytes);
    }

    /**
     * Plain SHA-256, deliberately not BCrypt. The input is 256 bits of CSPRNG output,
     * not a guessable human secret, so there is nothing for a slow hash to defend
     * against — and this runs on every authenticated request.
     */
    public String hash(String token) {
        try {
            byte[] out = MessageDigest.getInstance("SHA-256")
                    .digest(token.getBytes(StandardCharsets.UTF_8));
            StringBuilder sb = new StringBuilder(out.length * 2);
            for (byte b : out) {
                sb.append(Character.forDigit((b >> 4) & 0xF, 16));
                sb.append(Character.forDigit(b & 0xF, 16));
            }
            return sb.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new IllegalStateException("SHA-256 unavailable", e);
        }
    }
}
