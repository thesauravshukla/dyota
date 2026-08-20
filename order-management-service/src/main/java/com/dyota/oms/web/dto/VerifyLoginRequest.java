package com.dyota.oms.web.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;
import java.util.UUID;

public record VerifyLoginRequest(
        @NotNull UUID sessionId,
        @NotBlank @Pattern(regexp = "\\d{4,10}", message = "code must be 4-10 digits") String code) {
}
