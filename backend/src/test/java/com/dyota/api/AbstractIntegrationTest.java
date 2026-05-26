package com.dyota.api;

import com.dyota.api.auth.email.EmailService;
import com.dyota.api.auth.oauth.GoogleTokenVerifier;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.context.TestConfiguration;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.context.annotation.Import;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.JavaMailSenderImpl;
import org.springframework.test.context.DynamicPropertyRegistry;
import org.springframework.test.context.DynamicPropertySource;
import org.testcontainers.containers.PostgreSQLContainer;
import org.testcontainers.junit.jupiter.Container;
import org.testcontainers.junit.jupiter.Testcontainers;

import org.springframework.context.annotation.Bean;

@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
@Testcontainers
@Import(AbstractIntegrationTest.MailStubConfig.class)
public abstract class AbstractIntegrationTest {

    @Container
    static final PostgreSQLContainer<?> POSTGRES =
            new PostgreSQLContainer<>("postgres:16-alpine")
                    .withDatabaseName("dyota")
                    .withUsername("dyota")
                    .withPassword("changeme");

    @MockBean
    protected EmailService emailService;

    @MockBean
    protected GoogleTokenVerifier googleTokenVerifier;

    @DynamicPropertySource
    static void registerProperties(DynamicPropertyRegistry registry) {
        registry.add("spring.datasource.url", POSTGRES::getJdbcUrl);
        registry.add("spring.datasource.username", POSTGRES::getUsername);
        registry.add("spring.datasource.password", POSTGRES::getPassword);
        registry.add("dyota.jwt.secret", () -> "0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef");
        registry.add("dyota.oauth.google.audience", () -> "test.apps.googleusercontent.com");
        registry.add("dyota.email.base-url", () -> "http://localhost");
    }

    /**
     * Replace JavaMailSender with a no-op implementation so we never hit a real SMTP server in tests.
     * EmailService itself is mocked above for token capture.
     */
    @TestConfiguration
    static class MailStubConfig {
        @Bean
        JavaMailSender javaMailSender() {
            return new JavaMailSenderImpl();
        }
    }
}
