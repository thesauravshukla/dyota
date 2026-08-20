package com.dyota.oms.config;

import com.dyota.oms.session.service.SessionService;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.Clock;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

/**
 * Turns an opaque bearer token into a principal with a single indexed lookup.
 *
 * <p>There is no JWT to decode: the token carries no information at all, which is what
 * makes logout take effect immediately — the row is simply gone or revoked.
 */
@Component
public class TokenAuthenticationFilter extends OncePerRequestFilter {

    static final String PRINCIPAL_ATTRIBUTE = "com.dyota.oms.principal";

    private static final String BEARER = "Bearer ";

    private final SessionService sessions;
    private final Clock clock;

    public TokenAuthenticationFilter(SessionService sessions, Clock clock) {
        this.sessions = sessions;
        this.clock = clock;
    }

    /** Starting a login cannot itself require being logged in. */
    private static boolean isPublic(String path) {
        return path.startsWith("/actuator/")
                || path.startsWith("/api/v1/auth/login/");
    }

    @Override
    protected void doFilterInternal(
            HttpServletRequest request, HttpServletResponse response, FilterChain chain)
            throws ServletException, IOException {

        String token = bearerToken(request);
        if (token != null) {
            sessions.authenticate(token, clock.instant()).ifPresent(session ->
                    request.setAttribute(PRINCIPAL_ATTRIBUTE, new AuthenticatedUser(
                            session.getUserId(), session.getId(), token)));
        }

        if (!isPublic(request.getRequestURI())
                && request.getAttribute(PRINCIPAL_ATTRIBUTE) == null) {
            unauthorized(response);
            return;
        }
        chain.doFilter(request, response);
    }

    private static String bearerToken(HttpServletRequest request) {
        String header = request.getHeader(HttpHeaders.AUTHORIZATION);
        if (header == null || !header.startsWith(BEARER)) {
            return null;
        }
        String value = header.substring(BEARER.length()).trim();
        return value.isEmpty() ? null : value;
    }

    private static void unauthorized(HttpServletResponse response) throws IOException {
        response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
        response.setContentType(MediaType.APPLICATION_JSON_VALUE);
        response.getWriter().write(
                "{\"code\":\"UNAUTHENTICATED\",\"message\":\"Missing or invalid token\"}");
    }
}
