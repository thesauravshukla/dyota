package com.dyota.auth.otp.delivery;

import com.dyota.auth.session.domain.IdentifierType;
import com.dyota.auth.session.domain.Purpose;
import java.util.List;
import org.springframework.stereotype.Component;

/** Picks the sender that handles a given identifier type. */
@Component
public class OtpDispatcher {

    private final List<OtpSender> senders;

    public OtpDispatcher(List<OtpSender> senders) {
        this.senders = senders;
    }

    /** Whether any configured sender can actually deliver to this channel. */
    public boolean canDeliver(IdentifierType type) {
        return senders.stream().anyMatch(s -> s.supports(type));
    }

    public void dispatch(String identifier, IdentifierType type, String code, Purpose purpose) {
        OtpSender sender = senders.stream()
                .filter(s -> s.supports(type))
                .findFirst()
                .orElseThrow(() -> new IllegalStateException("No OtpSender supports " + type));
        sender.send(identifier, type, code, purpose);
    }
}
