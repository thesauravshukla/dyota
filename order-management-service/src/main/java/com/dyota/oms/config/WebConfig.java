package com.dyota.oms.config;

import java.util.List;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.method.support.HandlerMethodArgumentResolver;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig implements WebMvcConfigurer {

    private final ServiceProperties properties;
    private final AuthenticatedUserArgumentResolver principalResolver;

    public WebConfig(ServiceProperties properties, AuthenticatedUserArgumentResolver resolver) {
        this.properties = properties;
        this.principalResolver = resolver;
    }

    @Override
    public void addArgumentResolvers(List<HandlerMethodArgumentResolver> resolvers) {
        resolvers.add(principalResolver);
    }

    /** Unlike authentication-service, this API is reached directly by the client. */
    @Override
    public void addCorsMappings(CorsRegistry registry) {
        List<String> origins = properties.getCors().getAllowedOrigins();
        if (origins.isEmpty()) {
            return;
        }
        registry.addMapping("/api/**")
                .allowedOrigins(origins.toArray(String[]::new))
                .allowedMethods("GET", "POST", "PATCH", "DELETE", "OPTIONS")
                .allowedHeaders("*")
                .maxAge(3600);
    }
}
