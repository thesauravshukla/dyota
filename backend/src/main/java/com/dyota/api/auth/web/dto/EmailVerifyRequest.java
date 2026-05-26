package com.dyota.api.auth.web.dto;

import jakarta.validation.constraints.NotBlank;

public record EmailVerifyRequest(@NotBlank String token) {}
