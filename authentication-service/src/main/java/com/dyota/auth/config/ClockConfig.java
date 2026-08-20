package com.dyota.auth.config;

import java.time.Clock;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class ClockConfig {

    /** Injected everywhere instead of Instant.now(), so tests can move time deliberately. */
    @Bean
    public Clock clock() {
        return Clock.systemUTC();
    }
}
