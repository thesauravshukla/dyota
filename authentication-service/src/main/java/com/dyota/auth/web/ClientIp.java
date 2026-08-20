package com.dyota.auth.web;

import jakarta.servlet.http.HttpServletRequest;

/**
 * The service sits behind a gateway, so the socket address is the gateway's. The first
 * hop in X-Forwarded-For is the real client. This is only trustworthy because nothing
 * outside the mesh can reach this service directly.
 */
public final class ClientIp {

    private ClientIp() {
    }

    public static String of(HttpServletRequest request) {
        String forwarded = request.getHeader("X-Forwarded-For");
        if (forwarded != null && !forwarded.isBlank()) {
            int comma = forwarded.indexOf(',');
            String first = comma > 0 ? forwarded.substring(0, comma) : forwarded;
            return first.trim();
        }
        return request.getRemoteAddr();
    }
}
