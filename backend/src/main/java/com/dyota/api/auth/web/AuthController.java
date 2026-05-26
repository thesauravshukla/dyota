package com.dyota.api.auth.web;

import com.dyota.api.auth.domain.User;
import com.dyota.api.auth.repository.UserRepository;
import com.dyota.api.auth.service.AuthException;
import com.dyota.api.auth.service.AuthResult;
import com.dyota.api.auth.service.AuthService;
import com.dyota.api.auth.service.EmailVerificationService;
import com.dyota.api.auth.service.PasswordResetService;
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
import jakarta.validation.Valid;
import java.util.UUID;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/auth")
public class AuthController {

    private final AuthService authService;
    private final EmailVerificationService verificationService;
    private final PasswordResetService passwordResetService;
    private final UserRepository userRepo;

    public AuthController(
            AuthService authService,
            EmailVerificationService verificationService,
            PasswordResetService passwordResetService,
            UserRepository userRepo) {
        this.authService = authService;
        this.verificationService = verificationService;
        this.passwordResetService = passwordResetService;
        this.userRepo = userRepo;
    }

    @PostMapping("/signup")
    public ResponseEntity<AuthResponse> signup(@Valid @RequestBody SignupRequest body) {
        AuthResult result = authService.signup(body.email(), body.password(), body.confirmPassword());
        return ResponseEntity.status(HttpStatus.CREATED).body(AuthResponse.from(result));
    }

    @PostMapping("/login")
    public AuthResponse login(@Valid @RequestBody LoginRequest body) {
        return AuthResponse.from(authService.login(body.email(), body.password()));
    }

    @PostMapping("/refresh")
    public AuthResponse refresh(@Valid @RequestBody RefreshRequest body) {
        return AuthResponse.from(authService.refresh(body.refreshToken()));
    }

    @PostMapping("/logout")
    public ResponseEntity<Void> logout(@Valid @RequestBody LogoutRequest body) {
        authService.logout(body.refreshToken());
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/me")
    public UserDto me(Authentication authentication) {
        if (authentication == null || authentication.getPrincipal() == null) {
            throw AuthException.notAuthenticated();
        }
        UUID userId = UUID.fromString(authentication.getName());
        User user = userRepo.findById(userId).orElseThrow(AuthException::notAuthenticated);
        return UserDto.from(user);
    }

    @PostMapping("/email/verify")
    public ResponseEntity<Void> verifyEmail(@Valid @RequestBody EmailVerifyRequest body) {
        verificationService.confirm(body.token());
        return ResponseEntity.ok().build();
    }

    @PostMapping("/email/resend")
    public ResponseEntity<Void> resendVerification(@Valid @RequestBody EmailResendRequest body) {
        verificationService.resend(body.email());
        return ResponseEntity.noContent().build();
    }

    @PostMapping("/password/forgot")
    public ResponseEntity<Void> forgotPassword(@Valid @RequestBody PasswordForgotRequest body) {
        passwordResetService.requestReset(body.email());
        return ResponseEntity.noContent().build();
    }

    @PostMapping("/password/reset")
    public ResponseEntity<Void> resetPassword(@Valid @RequestBody PasswordResetRequest body) {
        passwordResetService.reset(body.token(), body.password());
        return ResponseEntity.ok().build();
    }

    @PostMapping("/oauth/google")
    public AuthResponse loginWithGoogle(@Valid @RequestBody GoogleOAuthRequest body) {
        return AuthResponse.from(authService.loginWithGoogle(body.idToken()));
    }
}
