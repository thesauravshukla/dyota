package com.dyota.oms.session;

import static org.assertj.core.api.Assertions.assertThat;

import com.dyota.oms.session.service.TokenFactory;
import java.util.HashSet;
import java.util.Set;
import org.junit.jupiter.api.Test;

class TokenFactoryTest {

    private final TokenFactory factory = new TokenFactory();

    @Test
    void tokensAreLongAndUrlSafe() {
        String token = factory.newToken();
        assertThat(token).hasSizeGreaterThanOrEqualTo(43).matches("[A-Za-z0-9_-]+");
    }

    @Test
    void tokensDoNotRepeat() {
        Set<String> seen = new HashSet<>();
        for (int i = 0; i < 1000; i++) {
            seen.add(factory.newToken());
        }
        assertThat(seen).hasSize(1000);
    }

    @Test
    void hashIsStableAndFixedWidth() {
        String token = factory.newToken();
        assertThat(factory.hash(token)).isEqualTo(factory.hash(token)).hasSize(64);
    }

    @Test
    void hashDoesNotRevealTheToken() {
        String token = factory.newToken();
        assertThat(factory.hash(token)).doesNotContain(token);
    }
}
