package com.dyota.api;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.atLeastOnce;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import com.dyota.api.auth.oauth.GoogleIdTokenClaims;
import com.dyota.api.auth.repository.RefreshTokenRepository;
import com.dyota.api.auth.repository.UserRepository;
import com.dyota.api.auth.web.dto.ApiError;
import com.dyota.api.auth.web.dto.AuthResponse;
import com.dyota.api.auth.web.dto.EmailResendRequest;
import com.dyota.api.auth.web.dto.EmailVerifyRequest;
import com.dyota.api.auth.web.dto.GoogleOAuthRequest;
import com.dyota.api.auth.web.dto.LoginRequest;
import com.dyota.api.auth.web.dto.LogoutRequest;
import com.dyota.api.auth.web.dto.PasswordForgotRequest;
import com.dyota.api.auth.web.dto.PasswordResetRequest;
import com.dyota.api.auth.web.dto.RefreshRequest;
import com.dyota.api.auth.web.dto.SignupRequest;
import com.dyota.api.auth.web.dto.UserDto;
import org.junit.jupiter.api.Test;
import org.mockito.ArgumentCaptor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.web.client.TestRestTemplate;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

class AuthIntegrationTest extends AbstractIntegrationTest {

    @Autowired
    TestRestTemplate rest;

    @Autowired
    UserRepository userRepo;

    @Autowired
    RefreshTokenRepository refreshTokenRepo;

    @Test
    void signupReturns201AndUserShape() {
        ResponseEntity<AuthResponse> response =
                rest.postForEntity("/api/v1/auth/signup",
                        new SignupRequest("signup@example.com", "Passw0rd!", "Passw0rd!"),
                        AuthResponse.class);

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.CREATED);
        AuthResponse body = response.getBody();
        assertThat(body).isNotNull();
        assertThat(body.user().email()).isEqualTo("signup@example.com");
        assertThat(body.user().emailVerified()).isFalse();
        assertThat(body.accessToken()).isNotBlank();
        assertThat(body.refreshToken()).contains(".");
    }

    @Test
    void signupRejectsPasswordMismatchWith400() {
        ResponseEntity<ApiError> response =
                rest.postForEntity("/api/v1/auth/signup",
                        new SignupRequest("mismatch@example.com", "Passw0rd!", "different"),
                        ApiError.class);

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.BAD_REQUEST);
        assertThat(response.getBody().code()).isEqualTo("PASSWORD_MISMATCH");
    }

    @Test
    void duplicateSignupReturns409() {
        signup("dup@example.com");

        ResponseEntity<ApiError> response =
                rest.postForEntity("/api/v1/auth/signup",
                        new SignupRequest("dup@example.com", "Passw0rd!", "Passw0rd!"),
                        ApiError.class);

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.CONFLICT);
        assertThat(response.getBody().code()).isEqualTo("EMAIL_EXISTS");
    }

    @Test
    void loginWithValidCredentialsReturns200() {
        signup("login@example.com");

        ResponseEntity<AuthResponse> response =
                rest.postForEntity("/api/v1/auth/login",
                        new LoginRequest("login@example.com", "Passw0rd!"),
                        AuthResponse.class);

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.OK);
        assertThat(response.getBody().user().email()).isEqualTo("login@example.com");
    }

    @Test
    void loginWithBadPasswordReturnsGeneric401() {
        signup("badpw@example.com");

        ResponseEntity<ApiError> response =
                rest.postForEntity("/api/v1/auth/login",
                        new LoginRequest("badpw@example.com", "wrong"),
                        ApiError.class);

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.UNAUTHORIZED);
        assertThat(response.getBody().code()).isEqualTo("INVALID_CREDENTIALS");
    }

    @Test
    void loginWithUnknownEmailReturnsGeneric401() {
        ResponseEntity<ApiError> response =
                rest.postForEntity("/api/v1/auth/login",
                        new LoginRequest("nobody@example.com", "Passw0rd!"),
                        ApiError.class);

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.UNAUTHORIZED);
        assertThat(response.getBody().code()).isEqualTo("INVALID_CREDENTIALS");
    }

    @Test
    void meReturnsCurrentUserWithBearer() {
        AuthResponse signed = signup("me@example.com");

        ResponseEntity<UserDto> response =
                rest.exchange("/api/v1/auth/me", HttpMethod.GET, bearer(signed.accessToken()), UserDto.class);

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.OK);
        assertThat(response.getBody().email()).isEqualTo("me@example.com");
    }

    @Test
    void meWithoutBearerReturns401() {
        ResponseEntity<ApiError> response =
                rest.getForEntity("/api/v1/auth/me", ApiError.class);

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.UNAUTHORIZED);
    }

    @Test
    void refreshRotatesToken() {
        AuthResponse signed = signup("rotate@example.com");

        ResponseEntity<AuthResponse> first =
                rest.postForEntity("/api/v1/auth/refresh",
                        new RefreshRequest(signed.refreshToken()),
                        AuthResponse.class);
        assertThat(first.getStatusCode()).isEqualTo(HttpStatus.OK);
        assertThat(first.getBody().refreshToken()).isNotEqualTo(signed.refreshToken());

        ResponseEntity<ApiError> reuse =
                rest.postForEntity("/api/v1/auth/refresh",
                        new RefreshRequest(signed.refreshToken()),
                        ApiError.class);
        assertThat(reuse.getStatusCode()).isEqualTo(HttpStatus.UNAUTHORIZED);
        assertThat(reuse.getBody().code()).isEqualTo("INVALID_REFRESH_TOKEN");
    }

    @Test
    void logoutRevokesRefreshToken() {
        AuthResponse signed = signup("logout@example.com");

        ResponseEntity<Void> logout =
                rest.postForEntity("/api/v1/auth/logout",
                        new LogoutRequest(signed.refreshToken()),
                        Void.class);
        assertThat(logout.getStatusCode()).isEqualTo(HttpStatus.NO_CONTENT);

        ResponseEntity<ApiError> reuse =
                rest.postForEntity("/api/v1/auth/refresh",
                        new RefreshRequest(signed.refreshToken()),
                        ApiError.class);
        assertThat(reuse.getStatusCode()).isEqualTo(HttpStatus.UNAUTHORIZED);
    }

    @Test
    void emailVerifyReturns200AndFlipsFlag() {
        AuthResponse signed = signup("verify@example.com");
        String token = captureSentToken("verify@example.com", true);

        ResponseEntity<Void> verify =
                rest.postForEntity("/api/v1/auth/email/verify",
                        new EmailVerifyRequest(token),
                        Void.class);
        assertThat(verify.getStatusCode()).isEqualTo(HttpStatus.OK);

        ResponseEntity<UserDto> me =
                rest.exchange("/api/v1/auth/me", HttpMethod.GET, bearer(signed.accessToken()), UserDto.class);
        assertThat(me.getBody().emailVerified()).isTrue();
    }

    @Test
    void emailVerifyWithBadTokenReturns400() {
        ResponseEntity<ApiError> response =
                rest.postForEntity("/api/v1/auth/email/verify",
                        new EmailVerifyRequest("not-a-real-token"),
                        ApiError.class);

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.BAD_REQUEST);
        assertThat(response.getBody().code()).isEqualTo("TOKEN_INVALID");
    }

    @Test
    void emailResendReturns204() {
        signup("resend@example.com");
        ResponseEntity<Void> response =
                rest.postForEntity("/api/v1/auth/email/resend",
                        new EmailResendRequest("resend@example.com"),
                        Void.class);

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.NO_CONTENT);
        verify(emailService, atLeastOnce()).sendVerificationEmail(eq("resend@example.com"), any());
    }

    @Test
    void forgotPasswordAlwaysReturns204() {
        signup("forgot@example.com");
        ResponseEntity<Void> known =
                rest.postForEntity("/api/v1/auth/password/forgot",
                        new PasswordForgotRequest("forgot@example.com"),
                        Void.class);
        ResponseEntity<Void> unknown =
                rest.postForEntity("/api/v1/auth/password/forgot",
                        new PasswordForgotRequest("nobody-here@example.com"),
                        Void.class);

        assertThat(known.getStatusCode()).isEqualTo(HttpStatus.NO_CONTENT);
        assertThat(unknown.getStatusCode()).isEqualTo(HttpStatus.NO_CONTENT);
        verify(emailService, never()).sendPasswordResetEmail(eq("nobody-here@example.com"), any());
    }

    @Test
    void passwordResetReturns200AndRevokesAllRefreshTokens() {
        AuthResponse signed = signup("reset@example.com");
        rest.postForEntity("/api/v1/auth/password/forgot",
                new PasswordForgotRequest("reset@example.com"),
                Void.class);
        String token = captureSentToken("reset@example.com", false);

        ResponseEntity<Void> reset =
                rest.postForEntity("/api/v1/auth/password/reset",
                        new PasswordResetRequest(token, "NewPassw0rd!"),
                        Void.class);
        assertThat(reset.getStatusCode()).isEqualTo(HttpStatus.OK);

        ResponseEntity<ApiError> oldLogin =
                rest.postForEntity("/api/v1/auth/login",
                        new LoginRequest("reset@example.com", "Passw0rd!"),
                        ApiError.class);
        assertThat(oldLogin.getStatusCode()).isEqualTo(HttpStatus.UNAUTHORIZED);

        ResponseEntity<AuthResponse> newLogin =
                rest.postForEntity("/api/v1/auth/login",
                        new LoginRequest("reset@example.com", "NewPassw0rd!"),
                        AuthResponse.class);
        assertThat(newLogin.getStatusCode()).isEqualTo(HttpStatus.OK);

        ResponseEntity<ApiError> oldRefresh =
                rest.postForEntity("/api/v1/auth/refresh",
                        new RefreshRequest(signed.refreshToken()),
                        ApiError.class);
        assertThat(oldRefresh.getStatusCode()).isEqualTo(HttpStatus.UNAUTHORIZED);
    }

    @Test
    void googleOauthCreatesUserAndIssuesTokens() {
        when(googleTokenVerifier.verify("good-id-token"))
                .thenReturn(new GoogleIdTokenClaims("google-sub-1", "g@example.com", true));

        ResponseEntity<AuthResponse> response =
                rest.postForEntity("/api/v1/auth/oauth/google",
                        new GoogleOAuthRequest("good-id-token"),
                        AuthResponse.class);

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.OK);
        assertThat(response.getBody().user().email()).isEqualTo("g@example.com");
        assertThat(response.getBody().user().emailVerified()).isTrue();
        assertThat(userRepo.findByEmail("g@example.com")).isPresent();
    }

    @Test
    void googleOauthWithInvalidTokenReturns401() {
        when(googleTokenVerifier.verify(any()))
                .thenThrow(com.dyota.api.auth.service.AuthException.oauthFailed());

        ResponseEntity<ApiError> response =
                rest.postForEntity("/api/v1/auth/oauth/google",
                        new GoogleOAuthRequest("bad-token"),
                        ApiError.class);

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.UNAUTHORIZED);
        assertThat(response.getBody().code()).isEqualTo("OAUTH_FAILED");
    }

    @Test
    void validationErrorReturns400() {
        ResponseEntity<ApiError> response =
                rest.postForEntity("/api/v1/auth/signup",
                        new SignupRequest("not-an-email", "x", "x"),
                        ApiError.class);

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.BAD_REQUEST);
        assertThat(response.getBody().code()).isEqualTo("VALIDATION_ERROR");
    }

    private AuthResponse signup(String email) {
        ResponseEntity<AuthResponse> response =
                rest.postForEntity("/api/v1/auth/signup",
                        new SignupRequest(email, "Passw0rd!", "Passw0rd!"),
                        AuthResponse.class);
        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.CREATED);
        return response.getBody();
    }

    private String captureSentToken(String email, boolean verification) {
        ArgumentCaptor<String> captor = ArgumentCaptor.forClass(String.class);
        if (verification) {
            verify(emailService, atLeastOnce()).sendVerificationEmail(eq(email), captor.capture());
        } else {
            verify(emailService, atLeastOnce()).sendPasswordResetEmail(eq(email), captor.capture());
        }
        return captor.getValue();
    }

    private static HttpEntity<Void> bearer(String accessToken) {
        HttpHeaders headers = new HttpHeaders();
        headers.setBearerAuth(accessToken);
        return new HttpEntity<>(headers);
    }
}
