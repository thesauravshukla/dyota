package com.dyota.auth.otp.service;

import java.security.SecureRandom;
import org.springframework.stereotype.Component;

/** Generates numeric codes with a CSPRNG. Leading zeros are preserved. */
@Component
public class OtpGenerator {

    private final SecureRandom random = new SecureRandom();

    public String generate(int length) {
        StringBuilder sb = new StringBuilder(length);
        for (int i = 0; i < length; i++) {
            sb.append(random.nextInt(10));
        }
        return sb.toString();
    }
}
