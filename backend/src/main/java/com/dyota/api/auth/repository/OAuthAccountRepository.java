package com.dyota.api.auth.repository;

import com.dyota.api.auth.domain.OAuthAccount;
import java.util.Optional;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;

public interface OAuthAccountRepository extends JpaRepository<OAuthAccount, UUID> {

    Optional<OAuthAccount> findByProviderAndSubject(String provider, String subject);
}
