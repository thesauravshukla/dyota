package com.dyota.auth.web;

import com.dyota.auth.verification.VerificationService;
import com.dyota.auth.web.dto.ResendOtpRequest;
import com.dyota.auth.web.dto.ResendOtpResponse;
import com.dyota.auth.web.dto.SendOtpRequest;
import com.dyota.auth.web.dto.SendOtpResponse;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/otp")
public class OtpController {

    private final VerificationService verification;

    public OtpController(VerificationService verification) {
        this.verification = verification;
    }

    @PostMapping("/send")
    public ResponseEntity<SendOtpResponse> send(
            @Valid @RequestBody SendOtpRequest request, HttpServletRequest http) {
        SendOtpResponse body = SendOtpResponse.from(verification.send(
                request.identifier(),
                request.identifierType(),
                request.purposeOrDefault(),
                request.userId(),
                ClientIp.of(http)));
        return ResponseEntity.status(HttpStatus.CREATED).body(body);
    }

    @PostMapping("/resend")
    public ResendOtpResponse resend(@Valid @RequestBody ResendOtpRequest request) {
        return ResendOtpResponse.from(verification.resend(request.sessionId()));
    }
}
