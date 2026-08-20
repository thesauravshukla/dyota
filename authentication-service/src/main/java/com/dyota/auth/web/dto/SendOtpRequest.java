package com.dyota.auth.web.dto;

import com.dyota.auth.session.domain.IdentifierType;
import com.dyota.auth.session.domain.Purpose;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import java.util.UUID;

public record SendOtpRequest(
        @NotBlank @Size(max = 320) String identifier,
        @NotNull IdentifierType identifierType,
        Purpose purpose,
        /** Opaque; stored on the session and echoed back on success. Never resolved. */
        UUID userId) {

    public Purpose purposeOrDefault() {
        return purpose == null ? Purpose.LOGIN : purpose;
    }
}
