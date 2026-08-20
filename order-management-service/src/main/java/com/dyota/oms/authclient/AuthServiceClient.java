package com.dyota.oms.authclient;

import com.dyota.oms.support.IdentifierType;
import java.util.UUID;

/**
 * The boundary to authentication-service. An interface so tests can exercise the whole
 * login flow without standing up the other service.
 */
public interface AuthServiceClient {

    OtpSendResult sendOtp(String identifier, IdentifierType type, String clientIp);

    OtpResendResult resendOtp(UUID sessionId, String clientIp);

    OtpVerifyResult verifyOtp(UUID sessionId, String code);
}
