package com.dyota.auth.otp.service;

import static org.assertj.core.api.Assertions.assertThat;

import java.util.HashSet;
import java.util.Set;
import org.junit.jupiter.api.Test;

class OtpGeneratorTest {

    private final OtpGenerator generator = new OtpGenerator();

    @Test
    void producesRequestedLengthOfDigits() {
        for (int len : new int[] {4, 6, 8}) {
            assertThat(generator.generate(len)).hasSize(len).containsOnlyDigits();
        }
    }

    @Test
    void preservesLeadingZeros() {
        // Generated as a string precisely so "012345" never collapses to 12345.
        boolean sawLeadingZero = false;
        for (int i = 0; i < 5000 && !sawLeadingZero; i++) {
            sawLeadingZero = generator.generate(6).startsWith("0");
        }
        assertThat(sawLeadingZero).isTrue();
    }

    @Test
    void doesNotRepeatItselfTrivially() {
        Set<String> seen = new HashSet<>();
        for (int i = 0; i < 500; i++) {
            seen.add(generator.generate(6));
        }
        assertThat(seen).hasSizeGreaterThan(450);
    }
}
