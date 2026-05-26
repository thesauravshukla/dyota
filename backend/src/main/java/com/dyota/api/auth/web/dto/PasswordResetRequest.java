package com.dyota.api.auth.web.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

public record PasswordResetRequest(
        @NotBlank String token, @NotBlank @Size(min = 8, max = 128) String password) {}
