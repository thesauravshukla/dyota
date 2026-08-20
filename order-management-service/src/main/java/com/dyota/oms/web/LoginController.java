package com.dyota.oms.web;

import com.dyota.oms.login.LoginService;
import com.dyota.oms.web.dto.ResendLoginRequest;
import com.dyota.oms.web.dto.ResendLoginResponse;
import com.dyota.oms.web.dto.StartLoginRequest;
import com.dyota.oms.web.dto.StartLoginResponse;
import com.dyota.oms.web.dto.VerifyLoginRequest;
import com.dyota.oms.web.dto.VerifyLoginResponse;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/** Public endpoints: these are what the Flutter client talks to. */
@RestController
@RequestMapping("/api/v1/auth/login")
public class LoginController {

    private final LoginService login;

    public LoginController(LoginService login) {
        this.login = login;
    }

    @PostMapping("/start")
    public StartLoginResponse start(
            @Valid @RequestBody StartLoginRequest request, HttpServletRequest http) {
        return StartLoginResponse.from(login.start(
                request.identifier(), request.identifierType(), ClientIp.of(http)));
    }

    @PostMapping("/resend")
    public ResendLoginResponse resend(
            @Valid @RequestBody ResendLoginRequest request, HttpServletRequest http) {
        return ResendLoginResponse.from(login.resend(request.sessionId(), ClientIp.of(http)));
    }

    @PostMapping("/verify")
    public VerifyLoginResponse verify(
            @Valid @RequestBody VerifyLoginRequest request, HttpServletRequest http) {
        return VerifyLoginResponse.from(login.verify(
                request.sessionId(), request.code(), DeviceLabel.of(http)));
    }
}
