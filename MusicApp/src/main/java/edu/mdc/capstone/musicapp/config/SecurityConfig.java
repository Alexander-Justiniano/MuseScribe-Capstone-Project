package edu.mdc.capstone.musicapp.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;

import edu.mdc.capstone.musicapp.service.UserDetailsServiceImpl;
import edu.mdc.capstone.musicapp.service.UserService;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    private final UserDetailsServiceImpl userDetailsService;
    private final UserService userService;

    public SecurityConfig(UserDetailsServiceImpl userDetailsService,
                          UserService userService) {
        this.userDetailsService = userDetailsService;
        this.userService = userService;
    }

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
            .csrf(csrf -> csrf
                .ignoringRequestMatchers("/api/**")
                .disable()
            )
            .authorizeHttpRequests(auth -> auth
                // allow your login & static resources and OAuth2 endpoints
                .requestMatchers(
                    "/login",
                    "/register",
                    "/forgotPassword",
                    "/oauth2/**",            // initial redirect
                    "/login/oauth2/**",      // callback from Google
                    "/api/**",
                    "/IMGS/**",
                    "/CSS/**",
                    "/JS/**",
                    "/webjars/**",
                    "/error",
                    "/WEB-INF/**"            // JSP forward
                ).permitAll()
                .anyRequest().authenticated()
            )
            .formLogin(form -> form
                .loginPage("/login")
                .loginProcessingUrl("/login")
                // now use our IdRedirectSuccessHandler for form login too
                .successHandler(idRedirectSuccessHandler())
                .permitAll()
            )
            .oauth2Login(oauth2 -> oauth2
                .loginPage("/login")
                // same handler for Google
                .successHandler(idRedirectSuccessHandler())
            )
            .logout(logout -> logout
                .logoutUrl("/logout")
                .logoutSuccessUrl("/login")
                .invalidateHttpSession(true)
                .deleteCookies("JSESSIONID")
                .permitAll()
            )
            .sessionManagement(session -> session
                .invalidSessionUrl("/login")
            );

        return http.build();
    }

    // our shared success handler
    @Bean
    public IdRedirectSuccessHandler idRedirectSuccessHandler() {
        return new IdRedirectSuccessHandler(userService);
    }

    @Bean
    public DaoAuthenticationProvider authenticationProvider() {
        var auth = new DaoAuthenticationProvider();
        auth.setUserDetailsService(userDetailsService);
        auth.setPasswordEncoder(new BCryptPasswordEncoder());
        return auth;
    }

    @Bean
    public AuthenticationManager authenticationManager(
            AuthenticationConfiguration config
    ) throws Exception {
        return config.getAuthenticationManager();
    }
}