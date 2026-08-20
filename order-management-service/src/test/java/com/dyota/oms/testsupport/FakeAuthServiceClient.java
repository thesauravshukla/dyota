package com.dyota.oms.testsupport;

import com.dyota.oms.authclient.AuthServiceClient;
import com.dyota.oms.authclient.OtpResendResult;
import com.dyota.oms.authclient.OtpSendResult;
import com.dyota.oms.authclient.OtpVerifyResult;
import com.dyota.oms.support.IdentifierType;
import java.time.Instant;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

/**
 * Stands in for authentication-service so the login flow can be tested without running
 * the other service. It also records the client IP it was handed, which is how the
 * forwarding behaviour is asserted.
 */
public class FakeAuthServiceClient implements AuthServiceClient {

    public String expectedCode = "123456";
    public String identifier = "+919876543210";
    public IdentifierType identifierType = IdentifierType.PHONE;
    public final List<String> forwardedIps = new ArrayList<>();
    public int attemptsRemainingOnFailure = 4;

    @Override
    public OtpSendResult sendOtp(String identifier, IdentifierType type, String clientIp) {
        forwardedIps.add(clientIp);
        this.identifier = identifier;
        this.identifierType = type;
        Instant now = Instant.now();
        return new OtpSendResult(UUID.randomUUID(), now.plusSeconds(900),
                now.plusSeconds(300), now.plusSeconds(30), 2);
    }

    @Override
    public OtpResendResult resendOtp(UUID sessionId, String clientIp) {
        forwardedIps.add(clientIp);
        Instant now = Instant.now();
        return new OtpResendResult(now.plusSeconds(30), now.plusSeconds(300), 1, false);
    }

    @Override
    public OtpVerifyResult verifyOtp(UUID sessionId, String code) {
        if (expectedCode.equals(code)) {
            return new OtpVerifyResult(true, true, null, null,
                    identifier, identifierType, Instant.now());
        }
        return new OtpVerifyResult(false, false, "INVALID_CODE",
                attemptsRemainingOnFailure, null, null, null);
    }

    public void reset() {
        forwardedIps.clear();
        expectedCode = "123456";
        identifier = "+919876543210";
        identifierType = IdentifierType.PHONE;
    }
}
