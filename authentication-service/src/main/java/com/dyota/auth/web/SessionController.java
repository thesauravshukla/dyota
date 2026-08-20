package com.dyota.auth.web;

import com.dyota.auth.verification.SessionStatusView;
import com.dyota.auth.verification.VerificationService;
import java.util.UUID;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/sessions")
public class SessionController {

    private final VerificationService verification;

    public SessionController(VerificationService verification) {
        this.verification = verification;
    }

    /** Status and counters only. The code is never exposed. */
    @GetMapping("/{sessionId}")
    public SessionStatusView status(@PathVariable UUID sessionId) {
        return verification.status(sessionId);
    }

    @PostMapping("/{sessionId}/terminate")
    public ResponseEntity<Void> terminate(@PathVariable UUID sessionId) {
        verification.terminate(sessionId);
        return ResponseEntity.noContent().build();
    }

    /** Same effect as terminate; offered so callers can use whichever verb fits them. */
    @DeleteMapping("/{sessionId}")
    public ResponseEntity<Void> delete(@PathVariable UUID sessionId) {
        verification.terminate(sessionId);
        return ResponseEntity.noContent().build();
    }
}
