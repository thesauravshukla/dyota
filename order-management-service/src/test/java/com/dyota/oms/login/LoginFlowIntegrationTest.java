package com.dyota.oms.login;

import static org.assertj.core.api.Assertions.assertThat;

import com.dyota.oms.AbstractIntegrationTest;
import com.dyota.oms.testsupport.FakeAuthServiceClient;
import com.dyota.oms.web.dto.StartLoginResponse;
import com.dyota.oms.web.dto.UserDto;
import com.dyota.oms.web.dto.VerifyLoginResponse;
import java.util.Map;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.web.client.TestRestTemplate;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.jdbc.core.JdbcTemplate;

class LoginFlowIntegrationTest extends AbstractIntegrationTest {

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

    private StartLoginResponse start(String identifier, String type) {
        return http.postForEntity("/api/v1/auth/login/start",
                Map.of("identifier", identifier, "identifierType", type),
                StartLoginResponse.class).getBody();
    }

    private ResponseEntity<VerifyLoginResponse> verify(StartLoginResponse started, String code) {
        return http.postForEntity("/api/v1/auth/login/verify",
                Map.of("sessionId", started.sessionId().toString(), "code", code),
                VerifyLoginResponse.class);
    }

    private HttpEntity<Void> bearer(String token) {
        HttpHeaders headers = new HttpHeaders();
        headers.setBearerAuth(token);
        return new HttpEntity<>(headers);
    }

    private String loginAndGetToken() {
        return verify(start("+919876543210", "PHONE"), "123456").getBody().token();
    }

    @Test
    void firstLoginCreatesTheAccountAndIssuesAToken() {
        ResponseEntity<VerifyLoginResponse> response = verify(start("+919876543210", "PHONE"), "123456");
        VerifyLoginResponse body = response.getBody();

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.OK);
        assertThat(body.authenticated()).isTrue();
        assertThat(body.isNewUser()).isTrue();
        assertThat(body.tokenType()).isEqualTo("Bearer");
        assertThat(body.token()).isNotBlank();
        assertThat(body.user().phone()).isEqualTo("+919876543210");
        assertThat(body.user().phoneVerified()).isTrue();
    }

    @Test
    void secondLoginReusesTheSameAccount() {
        VerifyLoginResponse first = verify(start("+919876543210", "PHONE"), "123456").getBody();
        VerifyLoginResponse second = verify(start("+919876543210", "PHONE"), "123456").getBody();

        assertThat(second.isNewUser()).isFalse();
        assertThat(second.user().id()).isEqualTo(first.user().id());
        assertThat(second.token()).isNotEqualTo(first.token());
        assertThat(jdbc.queryForObject("SELECT count(*) FROM app_user", Integer.class)).isEqualTo(1);
    }

    @Test
    void wrongCodeIsANormalOutcomeNotAnError() {
        ResponseEntity<VerifyLoginResponse> response = verify(start("+919876543210", "PHONE"), "999999");

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.OK);
        assertThat(response.getBody().authenticated()).isFalse();
        assertThat(response.getBody().reason()).isEqualTo("INVALID_CODE");
        assertThat(response.getBody().attemptsRemaining()).isEqualTo(4);
        assertThat(response.getBody().token()).isNull();
        assertThat(jdbc.queryForObject("SELECT count(*) FROM app_user", Integer.class)).isZero();
    }

    @Test
    void theTokenAuthenticatesSubsequentRequests() {
        String token = loginAndGetToken();

        ResponseEntity<UserDto> me = http.exchange(
                "/api/v1/auth/me", HttpMethod.GET, bearer(token), UserDto.class);

        assertThat(me.getStatusCode()).isEqualTo(HttpStatus.OK);
        assertThat(me.getBody().phone()).isEqualTo("+919876543210");
    }

    @Test
    void protectedRoutesRejectMissingOrBogusTokens() {
        assertThat(http.getForEntity("/api/v1/auth/me", String.class).getStatusCode())
                .isEqualTo(HttpStatus.UNAUTHORIZED);
        assertThat(http.exchange("/api/v1/auth/me", HttpMethod.GET,
                bearer("not-a-real-token"), String.class).getStatusCode())
                .isEqualTo(HttpStatus.UNAUTHORIZED);
    }

    @Test
    void logoutEndsThatSessionImmediately() {
        String token = loginAndGetToken();

        assertThat(http.exchange("/api/v1/auth/logout", HttpMethod.POST,
                bearer(token), Void.class).getStatusCode()).isEqualTo(HttpStatus.NO_CONTENT);

        // The whole point of opaque tokens: revocation takes effect on the next request.
        assertThat(http.exchange("/api/v1/auth/me", HttpMethod.GET, bearer(token), String.class)
                .getStatusCode()).isEqualTo(HttpStatus.UNAUTHORIZED);
    }

    @Test
    void loggingInOnASecondDeviceLeavesTheFirstAlone() {
        String phone = loginAndGetToken();
        String tablet = loginAndGetToken();

        assertThat(http.exchange("/api/v1/auth/me", HttpMethod.GET, bearer(phone), String.class)
                .getStatusCode()).isEqualTo(HttpStatus.OK);
        assertThat(http.exchange("/api/v1/auth/me", HttpMethod.GET, bearer(tablet), String.class)
                .getStatusCode()).isEqualTo(HttpStatus.OK);
    }

    @Test
    void logoutAllEndsEverySession() {
        String phone = loginAndGetToken();
        String tablet = loginAndGetToken();

        http.exchange("/api/v1/auth/logout/all", HttpMethod.POST, bearer(phone), Void.class);

        assertThat(http.exchange("/api/v1/auth/me", HttpMethod.GET, bearer(phone), String.class)
                .getStatusCode()).isEqualTo(HttpStatus.UNAUTHORIZED);
        assertThat(http.exchange("/api/v1/auth/me", HttpMethod.GET, bearer(tablet), String.class)
                .getStatusCode()).isEqualTo(HttpStatus.UNAUTHORIZED);
    }

    @Test
    void emailLoginWorksTheSameWay() {
        authService.identifierType = com.dyota.oms.support.IdentifierType.EMAIL;
        authService.identifier = "user@example.com";

        VerifyLoginResponse body = verify(start("user@example.com", "EMAIL"), "123456").getBody();

        assertThat(body.authenticated()).isTrue();
        assertThat(body.user().email()).isEqualTo("user@example.com");
        assertThat(body.user().emailVerified()).isTrue();
        assertThat(body.user().phone()).isNull();
    }

    @Test
    void malformedIdentifierNeverReachesTheVerificationService() {
        ResponseEntity<String> response = http.postForEntity("/api/v1/auth/login/start",
                Map.of("identifier", "9876543210", "identifierType", "PHONE"), String.class);

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.BAD_REQUEST);
        assertThat(response.getBody()).contains("INVALID_IDENTIFIER");
        assertThat(authService.forwardedIps).isEmpty();
    }

    /**
     * authentication-service rate limits per IP. If this service did not forward the
     * caller's address, that cap would see one address for every user on earth.
     */
    @Test
    void theCallersIpIsForwardedToTheVerificationService() {
        start("+919876543210", "PHONE");
        assertThat(authService.forwardedIps).hasSize(1);
        assertThat(authService.forwardedIps.get(0)).isNotBlank();
    }
}
