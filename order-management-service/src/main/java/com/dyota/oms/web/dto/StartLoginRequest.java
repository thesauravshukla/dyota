package com.dyota.oms.web.dto;

import com.dyota.oms.support.IdentifierType;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

public record StartLoginRequest(
        @NotBlank @Size(max = 320) String identifier,
        @NotNull IdentifierType identifierType) {
}
