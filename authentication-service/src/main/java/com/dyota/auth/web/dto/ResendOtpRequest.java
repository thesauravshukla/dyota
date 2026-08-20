package com.dyota.auth.web.dto;

import jakarta.validation.constraints.NotNull;
import java.util.UUID;

public record ResendOtpRequest(@NotNull UUID sessionId) {
}
