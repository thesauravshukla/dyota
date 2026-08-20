package com.dyota.oms.web;

import jakarta.servlet.http.HttpServletRequest;
import org.springframework.http.HttpHeaders;

/** Best-effort device description, so a user can recognise their own sessions. */
public final class DeviceLabel {

    private static final int MAX = 200;

    private DeviceLabel() {
    }

    public static String of(HttpServletRequest request) {
        String agent = request.getHeader(HttpHeaders.USER_AGENT);
        if (agent == null || agent.isBlank()) {
            return null;
        }
        return agent.length() <= MAX ? agent : agent.substring(0, MAX);
    }
}
