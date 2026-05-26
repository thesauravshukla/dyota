package com.dyota.api.auth.oauth;

import com.dyota.api.auth.service.AuthException;
import com.dyota.api.config.AppProperties;
import com.nimbusds.jose.JWSAlgorithm;
import com.nimbusds.jose.jwk.source.JWKSource;
import com.nimbusds.jose.jwk.source.JWKSourceBuilder;
import com.nimbusds.jose.proc.JWSKeySelector;
import com.nimbusds.jose.proc.JWSVerificationKeySelector;
import com.nimbusds.jose.proc.SecurityContext;
import com.nimbusds.jwt.JWTClaimsSet;
import com.nimbusds.jwt.SignedJWT;
import com.nimbusds.jwt.proc.ConfigurableJWTProcessor;
import com.nimbusds.jwt.proc.DefaultJWTClaimsVerifier;
import com.nimbusds.jwt.proc.DefaultJWTProcessor;
import java.net.URL;
import java.text.ParseException;
import java.util.Date;
import java.util.Set;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

@Component
public class GoogleTokenVerifier {

    private static final Logger log = LoggerFactory.getLogger(GoogleTokenVerifier.class);
    private static final String JWKS_URL = "https://www.googleapis.com/oauth2/v3/certs";
    private static final Set<String> ALLOWED_ISSUERS = Set.of("https://accounts.google.com", "accounts.google.com");

    private final ConfigurableJWTProcessor<SecurityContext> processor;

    public GoogleTokenVerifier(AppProperties props) throws Exception {
        String audience = props.oauth().google().audience();
        if (audience == null || audience.isBlank()) {
            log.warn("dyota.oauth.google.audience is not set; Google sign-in will fail until configured.");
        }
        JWKSource<SecurityContext> jwkSource = JWKSourceBuilder
                .create(new URL(JWKS_URL))
                .retrying(true)
                .build();
        JWSKeySelector<SecurityContext> keySelector = new JWSVerificationKeySelector<>(JWSAlgorithm.RS256, jwkSource);
        DefaultJWTProcessor<SecurityContext> p = new DefaultJWTProcessor<>();
        p.setJWSKeySelector(keySelector);
        p.setJWTClaimsSetVerifier(new DefaultJWTClaimsVerifier<>(
                audience == null ? "" : audience,
                null,
                Set.of("sub", "email", "iss", "aud", "exp")));
        this.processor = p;
    }

    public GoogleIdTokenClaims verify(String idToken) {
        try {
            SignedJWT jwt = SignedJWT.parse(idToken);
            JWTClaimsSet claims = processor.process(jwt, null);
            String iss = claims.getIssuer();
            if (iss == null || !ALLOWED_ISSUERS.contains(iss)) {
                throw AuthException.oauthFailed();
            }
            Date exp = claims.getExpirationTime();
            if (exp == null || exp.before(new Date())) {
                throw AuthException.oauthFailed();
            }
            String subject = claims.getSubject();
            String email = claims.getStringClaim("email");
            Boolean emailVerified = claims.getBooleanClaim("email_verified");
            if (subject == null || email == null) {
                throw AuthException.oauthFailed();
            }
            return new GoogleIdTokenClaims(subject, email, Boolean.TRUE.equals(emailVerified));
        } catch (ParseException e) {
            throw AuthException.oauthFailed();
        } catch (AuthException e) {
            throw e;
        } catch (Exception e) {
            log.debug("Google ID token verification failed", e);
            throw AuthException.oauthFailed();
        }
    }
}
