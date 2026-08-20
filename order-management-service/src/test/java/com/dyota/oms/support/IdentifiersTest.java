package com.dyota.oms.support;

import static org.assertj.core.api.Assertions.assertThat;

import org.junit.jupiter.api.Test;

class IdentifiersTest {

    @Test
    void validatesEmailAndPhone() {
        assertThat(Identifiers.isValid("user@example.com", IdentifierType.EMAIL)).isTrue();
        assertThat(Identifiers.isValid("nope", IdentifierType.EMAIL)).isFalse();
        assertThat(Identifiers.isValid("+919876543210", IdentifierType.PHONE)).isTrue();
        assertThat(Identifiers.isValid("9876543210", IdentifierType.PHONE)).isFalse();
    }

    @Test
    void normalisesEmailCaseOnly() {
        assertThat(Identifiers.normalise(" User@Example.COM ", IdentifierType.EMAIL))
                .isEqualTo("user@example.com");
        assertThat(Identifiers.normalise(" +919876543210 ", IdentifierType.PHONE))
                .isEqualTo("+919876543210");
    }
}
