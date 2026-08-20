package com.dyota.oms.user.repository;

import com.dyota.oms.user.domain.AppUser;
import java.util.Optional;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;

public interface AppUserRepository extends JpaRepository<AppUser, UUID> {

    Optional<AppUser> findByPhone(String phone);

    Optional<AppUser> findByEmail(String email);
}
