package com.dyota.oms.config;

import java.util.UUID;

/** Resolved from the bearer token and injected into controller methods. */
public record AuthenticatedUser(UUID userId, UUID sessionId, String token) {
}
