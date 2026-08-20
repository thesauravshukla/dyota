package com.dyota.auth.config;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

/**
 * This service is internal-only: the login API is its sole caller. A shared key is the
 * minimum bar; mTLS or a service mesh identity is the better answer in production.
 *
 * <p>Left blank the check is skipped, which is intended for local development only —
 * a public deployment without a key would let anyone burn the SMS budget.
 */
@Component
public class ServiceApiKeyFilter extends OncePerRequestFilter {

    private static final Logger log = LoggerFactory.getLogger(ServiceApiKeyFilter.class);
    private static final String HEADER = "X-Service-Key";

    private final AuthProperties properties;

    public ServiceApiKeyFilter(AuthProperties properties) {
        this.properties = properties;
    }

    @Override
    protected boolean shouldNotFilter(HttpServletRequest request) {
        String path = request.getRequestURI();
        return path.startsWith("/actuator/");
    }

    @Override
    protected void doFilterInternal(
            HttpServletRequest request, HttpServletResponse response, FilterChain chain)
            throws ServletException, IOException {

        String expected = properties.getServiceApiKey();
        if (expected == null || expected.isBlank()) {
            chain.doFilter(request, response);
            return;
        }

        String presented = request.getHeader(HEADER);
        if (presented == null || !constantTimeEquals(expected, presented)) {
            log.warn("Rejected unauthenticated call to {}", request.getRequestURI());
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.setContentType(MediaType.APPLICATION_JSON_VALUE);
            response.getWriter().write(
                    "{\"code\":\"SERVICE_UNAUTHORIZED\",\"message\":\"Invalid or missing service key\"}");
            return;
        }
        chain.doFilter(request, response);
    }

    private static boolean constantTimeEquals(String a, String b) {
        return MessageDigest.isEqual(
                a.getBytes(StandardCharsets.UTF_8), b.getBytes(StandardCharsets.UTF_8));
    }
}
