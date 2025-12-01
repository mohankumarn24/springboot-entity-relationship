package net.projectsync.entityrelationship.config;

import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Info;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class SwaggerConfig {

    @Bean
    public OpenAPI apiInfo() {
        return new OpenAPI()
                .info(new Info()
                        .title("Student Management API")
                        .description("CRUD and Join Queries using JPA + PostgreSQL")
                        .version("1.0"));
    }
}

// http://localhost:8080/swagger-ui.html