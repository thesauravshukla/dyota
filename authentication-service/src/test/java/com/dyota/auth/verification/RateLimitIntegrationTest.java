package com.dyota.auth.verification;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

import com.dyota.auth.AbstractIntegrationTest;
import com.dyota.auth.session.domain.IdentifierType;
import com.dyota.auth.session.domain.Purpose;
import com.dyota.auth.support.AuthServiceException;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.test.context.TestPropertySource;

@TestPropertySource(properties = {
        "auth.rate-limit.per-identifier-sends=2",
        "auth.rate-limit.per-ip-sends=100"
})
class RateLimitIntegrationTest extends AbstractIntegrationTest {

    @Autowired
    VerificationService verification;
    @Autowired
    JdbcTemplate jdbc;

    @BeforeEach
    void reset() {
        jdbc.update("DELETE FROM verification_session");
        jdbc.update("DELETE FROM rate_counter");
    }

    /**
     * The per-session cap alone protects nothing: an attacker just opens a new session
     * per send. This is the control that actually contains that.
     */
    @Test
    void freshSessionsCannotBeUsedToBypassTheSendCap() {
        verification.send("a@example.com", IdentifierType.EMAIL, Purpose.LOGIN, null, "203.0.113.1");
        verification.send("a@example.com", IdentifierType.EMAIL, Purpose.LOGIN, null, "203.0.113.1");

        assertThatThrownBy(() -> verification.send("a@example.com", IdentifierType.EMAIL,
                Purpose.LOGIN, null, "203.0.113.1"))
                .isInstanceOf(AuthServiceException.class)
                .extracting(e -> ((AuthServiceException) e).getCode())
                .isEqualTo("IDENTIFIER_RATE_LIMITED");
    }

    @Test
    void countersSurviveSessionCleanup() {
        verification.send("b@example.com", IdentifierType.EMAIL, Purpose.LOGIN, null, "203.0.113.2");
        jdbc.update("DELETE FROM verification_session");

        // Budget must not reset just because the sessions were swept away.
        verification.send("b@example.com", IdentifierType.EMAIL, Purpose.LOGIN, null, "203.0.113.2");
        assertThatThrownBy(() -> verification.send("b@example.com", IdentifierType.EMAIL,
                Purpose.LOGIN, null, "203.0.113.2"))
                .isInstanceOf(AuthServiceException.class);

        Integer counters = jdbc.queryForObject(
                "SELECT count(*) FROM rate_counter WHERE scope = 'IDENTIFIER'", Integer.class);
        assertThat(counters).isEqualTo(1);
    }

    @Test
    void differentIdentifiersHaveIndependentBudgets() {
        verification.send("c@example.com", IdentifierType.EMAIL, Purpose.LOGIN, null, "203.0.113.3");
        verification.send("c@example.com", IdentifierType.EMAIL, Purpose.LOGIN, null, "203.0.113.3");
        // A different identifier is unaffected by the first one's exhausted budget.
        verification.send("d@example.com", IdentifierType.EMAIL, Purpose.LOGIN, null, "203.0.113.3");
    }
}
