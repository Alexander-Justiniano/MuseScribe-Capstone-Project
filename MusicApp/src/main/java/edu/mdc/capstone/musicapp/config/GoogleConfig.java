package edu.mdc.capstone.musicapp.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
public class GoogleConfig {

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
          // ---- DISABLE CSRF API ----
          .csrf(csrf -> csrf
            // narrow to only /api/** 
            .ignoringRequestMatchers("/api/**")
            .disable()
          )
          // for CORS add:
          // .cors(Customizer.withDefaults()).and()

          // Authorization rules
          .authorizeHttpRequests(registry -> registry
            .requestMatchers(
              "/login",
              "/IMGS/**",
              "/CSS/**",
              "/JS/**",
              "/api/**"     // endpoints
            ).permitAll()
            .anyRequest().authenticated()
          )
          .oauth2Login(Customizer.withDefaults());

        return http.build();
    }
}
