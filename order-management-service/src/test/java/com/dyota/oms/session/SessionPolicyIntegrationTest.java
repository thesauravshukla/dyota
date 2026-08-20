package com.dyota.oms.session;

import static org.assertj.core.api.Assertions.assertThat;

import com.dyota.oms.AbstractIntegrationTest;
import com.dyota.oms.testsupport.FakeAuthServiceClient;
import com.dyota.oms.web.dto.VerifyLoginResponse;
import java.util.Map;
import java.util.UUID;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.web.client.TestRestTemplate;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.HttpStatus;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.test.context.TestPropertySource;

@TestPropertySource(properties = "oms.session.max-per-user=2")
class SessionPolicyIntegrationTest extends AbstractIntegrationTest {

    @Autowired
    TestRestTemplate http;
    @Autowired
    FakeAuthServiceClient authService;
    @Autowired
    JdbcTemplate jdbc;

    @BeforeEach
    void reset() {
        jdbc.update("DELETE FROM user_session");
        jdbc.update("DELETE FROM app_user");
        authService.reset();
    }

    private String login() {
        UUID sessionId = http.postForEntity("/api/v1/auth/login/start",
                Map.of("identifier", "+919876543210", "identifierType", "PHONE"),
                com.dyota.oms.web.dto.StartLoginResponse.class).getBody().sessionId();
        return http.postForEntity("/api/v1/auth/login/verify",
                Map.of("sessionId", sessionId.toString(), "code", "123456"),
                VerifyLoginResponse.class).getBody().token();
    }

    private HttpStatus statusOfMe(String token) {
        HttpHeaders headers = new HttpHeaders();
        headers.setBearerAuth(token);
        return (HttpStatus) http.exchange("/api/v1/auth/me", HttpMethod.GET,
                new HttpEntity<>(headers), String.class).getStatusCode();
    }

    /** The table must never hold anything that could be replayed as a credential. */
    @Test
    void theRawTokenIsNeverStored() {
        String token = login();

        Integer matches = jdbc.queryForObject(
                "SELECT count(*) FROM user_session WHERE token_hash = ?", Integer.class, token);
        assertThat(matches).isZero();

        String stored = jdbc.queryForObject(
                "SELECT token_hash FROM user_session LIMIT 1", String.class);
        assertThat(stored).hasSize(64).isNotEqualTo(token);
    }

    @Test
    void theOldestSessionIsRevokedOnceTheCapIsReached() {
        String first = login();
        String second = login();
        assertThat(statusOfMe(first)).isEqualTo(HttpStatus.OK);

        String third = login();

        // Cap is 2: the first device is pushed out, the two newest survive.
        assertThat(statusOfMe(first)).isEqualTo(HttpStatus.UNAUTHORIZED);
        assertThat(statusOfMe(second)).isEqualTo(HttpStatus.OK);
        assertThat(statusOfMe(third)).isEqualTo(HttpStatus.OK);
    }

    @Test
    void capCountsOnlyLiveSessions() {
        String first = login();
        HttpHeaders headers = new HttpHeaders();
        headers.setBearerAuth(first);
        http.exchange("/api/v1/auth/logout", HttpMethod.POST, new HttpEntity<>(headers), Void.class);

        // Logging out freed a slot, so this pair should both survive.
        String second = login();
        String third = login();
        assertThat(statusOfMe(second)).isEqualTo(HttpStatus.OK);
        assertThat(statusOfMe(third)).isEqualTo(HttpStatus.OK);
    }

    @Test
    void suspendedAccountsCannotLogIn() {
        login();
        jdbc.update("UPDATE app_user SET status = 'SUSPENDED'");

        UUID sessionId = http.postForEntity("/api/v1/auth/login/start",
                Map.of("identifier", "+919876543210", "identifierType", "PHONE"),
                com.dyota.oms.web.dto.StartLoginResponse.class).getBody().sessionId();
        var response = http.postForEntity("/api/v1/auth/login/verify",
                Map.of("sessionId", sessionId.toString(), "code", "123456"), String.class);

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.FORBIDDEN);
        assertThat(response.getBody()).contains("ACCOUNT_SUSPENDED");
    }

    @Test
    void sessionsEndpointListsDevicesAndFlagsTheCurrentOne() {
        String first = login();
        String second = login();

        HttpHeaders headers = new HttpHeaders();
        headers.setBearerAuth(second);
        var response = http.exchange("/api/v1/auth/sessions", HttpMethod.GET,
                new HttpEntity<>(headers), String.class);

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.OK);
        assertThat(response.getBody()).contains("\"current\":true");
        assertThat(first).isNotEqualTo(second);
    }
}
