package com.dyota.auth.otp.delivery;

import com.dyota.auth.session.domain.IdentifierType;
import com.dyota.auth.session.domain.Purpose;

/** Delivery strategy for one channel. Resolved per identifier type at dispatch time. */
public interface OtpSender {

    boolean supports(IdentifierType type);

    void send(String identifier, IdentifierType type, String code, Purpose purpose);
}
