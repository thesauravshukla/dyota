package com.dyota.oms.support;

import java.util.regex.Pattern;

/** Same rules as authentication-service, duplicated to keep the services independent. */
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

    public static String mask(String identifier) {
        if (identifier == null || identifier.isBlank()) {
            return "<blank>";
        }
        int at = identifier.indexOf('@');
        if (at > 0) {
            String local = identifier.substring(0, at);
            return local.substring(0, Math.min(2, local.length())) + "***" + identifier.substring(at);
        }
        if (identifier.length() <= 4) {
            return "***";
        }
        return identifier.substring(0, 3) + "****" + identifier.substring(identifier.length() - 2);
    }
}
