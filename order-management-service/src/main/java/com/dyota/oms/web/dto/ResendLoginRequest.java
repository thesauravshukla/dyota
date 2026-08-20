package com.dyota.oms.web.dto;

import jakarta.validation.constraints.NotNull;
import java.util.UUID;

public record ResendLoginRequest(@NotNull UUID sessionId) {
}
