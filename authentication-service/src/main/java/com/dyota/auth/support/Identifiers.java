package com.dyota.auth.support;

import com.dyota.auth.session.domain.IdentifierType;
import java.util.regex.Pattern;

/** Validation and log-masking for the one piece of PII this service touches. */
public final class Identifiers {

    private static final Pattern EMAIL = Pattern.compile("^[^@\\s]+@[^@\\s.]+\\.[^@\\s]+$");
    private static final Pattern E164 = Pattern.compile("^\\+[1-9]\\d{7,14}$");

    private Identifiers() {
    }

    public static boolean isValid(String identifier, IdentifierType type) {
        if (identifier == null || identifier.isBlank()) {
            return false;
        }
        return switch (type) {
            case EMAIL -> identifier.length() <= 320 && EMAIL.matcher(identifier).matches();
            case PHONE -> E164.matcher(identifier).matches();
        };
    }

    public static String normalise(String identifier, IdentifierType type) {
        String trimmed = identifier == null ? "" : identifier.trim();
        return type == IdentifierType.EMAIL ? trimmed.toLowerCase() : trimmed;
    }

    /**
     * Masks an identifier for logging. Full identifiers must never reach the logs,
     * because log aggregation typically has a far longer retention than these sessions.
     */
    public static String mask(String identifier) {
        if (identifier == null || identifier.isBlank()) {
            return "<blank>";
        }
        int at = identifier.indexOf('@');
        if (at > 0) {
            String local = identifier.substring(0, at);
            String domain = identifier.substring(at);
            String head = local.substring(0, Math.min(2, local.length()));
            return head + "***" + domain;
        }
        if (identifier.length() <= 4) {
            return "***";
        }
        return identifier.substring(0, 3) + "****" + identifier.substring(identifier.length() - 2);
    }
}
