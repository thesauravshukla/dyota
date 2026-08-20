package com.dyota.auth;

import com.dyota.auth.testsupport.MutableClock;
import com.dyota.auth.testsupport.RecordingOtpSender;
import java.time.Instant;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.context.TestConfiguration;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Import;
import org.springframework.context.annotation.Primary;
import org.springframework.test.context.DynamicPropertyRegistry;
import org.springframework.test.context.DynamicPropertySource;
import org.testcontainers.containers.PostgreSQLContainer;
import org.testcontainers.junit.jupiter.Container;
import org.testcontainers.junit.jupiter.Testcontainers;

/**
 * Runs against a real Postgres, because the invariants worth testing here — the partial
 * unique index, ON DELETE CASCADE, SELECT FOR UPDATE — only exist in the database.
 */
@SpringBootTest
@Testcontainers
@Import(AbstractIntegrationTest.TestBeans.class)
public abstract class AbstractIntegrationTest {

    @Container
    static final PostgreSQLContainer<?> POSTGRES =
            new PostgreSQLContainer<>("postgres:16-alpine")
                    .withDatabaseName("auth")
                    .withUsername("authsvc")
                    .withPassword("test");

    @DynamicPropertySource
    static void datasource(DynamicPropertyRegistry registry) {
        registry.add("spring.datasource.url", POSTGRES::getJdbcUrl);
        registry.add("spring.datasource.username", POSTGRES::getUsername);
        registry.add("spring.datasource.password", POSTGRES::getPassword);
        // Disables every production sender so nothing tries to send a real message.
        registry.add("auth.otp.sender", () -> "test");
    }

    @TestConfiguration
    static class TestBeans {

        /**
         * Marked primary rather than replacing the production 'clock' bean: Spring Boot
         * forbids bean definition overriding, and a primary candidate wins cleanly
         * without loosening that setting for the whole test context.
         */
        @Bean
        @Primary
        MutableClock mutableClock() {
            return new MutableClock(Instant.parse("2026-01-01T00:00:00Z"));
        }

        @Bean
        RecordingOtpSender recordingOtpSender() {
            return new RecordingOtpSender();
        }
    }
}
