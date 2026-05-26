package com.dyota.api;

import com.dyota.api.config.AppProperties;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.context.properties.ConfigurationPropertiesScan;

@SpringBootApplication
@ConfigurationPropertiesScan(basePackageClasses = AppProperties.class)
public class DyotaApiApplication {

    public static void main(String[] args) {
        SpringApplication.run(DyotaApiApplication.class, args);
    }
}
