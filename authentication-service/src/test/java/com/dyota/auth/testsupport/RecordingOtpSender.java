package com.dyota.auth.testsupport;

import com.dyota.auth.otp.delivery.OtpSender;
import com.dyota.auth.session.domain.IdentifierType;
import com.dyota.auth.session.domain.Purpose;
import java.util.ArrayList;
import java.util.List;

/** Captures dispatched codes so tests can assert on what was actually delivered. */
public class RecordingOtpSender implements OtpSender {

    public record Dispatch(String identifier, IdentifierType type, String code, Purpose purpose) {
    }

    private final List<Dispatch> dispatches = new ArrayList<>();

    @Override
    public boolean supports(IdentifierType type) {
        return true;
    }

    @Override
    public synchronized void send(
            String identifier, IdentifierType type, String code, Purpose purpose) {
        dispatches.add(new Dispatch(identifier, type, code, purpose));
    }

    public synchronized List<Dispatch> all() {
        return List.copyOf(dispatches);
    }

    public synchronized String lastCode() {
        return dispatches.isEmpty() ? null : dispatches.get(dispatches.size() - 1).code();
    }

    public synchronized int count() {
        return dispatches.size();
    }

    public synchronized void clear() {
        dispatches.clear();
    }
}
