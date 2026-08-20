package com.dyota.auth.web;

import com.dyota.auth.verification.VerificationService;
import com.dyota.auth.web.dto.VerifyRequest;
import com.dyota.auth.web.dto.VerifyResponse;
import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1")
public class VerificationController {

    private final VerificationService verification;

    public VerificationController(VerificationService verification) {
        this.verification = verification;
    }

    /** Submits a code and answers whether this session may proceed to login. */
    @PostMapping("/verify")
    public VerifyResponse verify(@Valid @RequestBody VerifyRequest request) {
        return VerifyResponse.from(verification.verify(request.sessionId(), request.code()));
    }
}
