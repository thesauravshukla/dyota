package com.dyota.auth.support;

import static org.assertj.core.api.Assertions.assertThat;

import com.dyota.auth.session.domain.IdentifierType;
import org.junit.jupiter.api.Test;

class IdentifiersTest {

    @Test
    void acceptsWellFormedEmail() {
        assertThat(Identifiers.isValid("user@example.com", IdentifierType.EMAIL)).isTrue();
    }

    @Test
    void rejectsMalformedEmail() {
        assertThat(Identifiers.isValid("user@example", IdentifierType.EMAIL)).isFalse();
        assertThat(Identifiers.isValid("no-at-sign.com", IdentifierType.EMAIL)).isFalse();
        assertThat(Identifiers.isValid("", IdentifierType.EMAIL)).isFalse();
    }

    @Test
    void acceptsE164PhoneOnly() {
        assertThat(Identifiers.isValid("+919876543210", IdentifierType.PHONE)).isTrue();
        assertThat(Identifiers.isValid("9876543210", IdentifierType.PHONE)).isFalse();
        assertThat(Identifiers.isValid("+0123456789", IdentifierType.PHONE)).isFalse();
    }

    @Test
    void lowercasesEmailButLeavesPhoneAlone() {
        assertThat(Identifiers.normalise("  User@Example.COM ", IdentifierType.EMAIL))
                .isEqualTo("user@example.com");
        assertThat(Identifiers.normalise(" +919876543210 ", IdentifierType.PHONE))
                .isEqualTo("+919876543210");
    }

    @Test
    void maskingNeverRevealsTheWholeIdentifier() {
        assertThat(Identifiers.mask("user@example.com")).isEqualTo("us***@example.com");
        assertThat(Identifiers.mask("+919876543210")).isEqualTo("+91****10");
        assertThat(Identifiers.mask("abc")).isEqualTo("***");
    }
}
