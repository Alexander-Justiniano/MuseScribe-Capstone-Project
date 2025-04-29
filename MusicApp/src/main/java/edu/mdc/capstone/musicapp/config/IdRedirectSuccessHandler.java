package edu.mdc.capstone.musicapp.config;

import java.io.IOException;
import java.util.Optional;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;

import edu.mdc.capstone.musicapp.models.User;
import edu.mdc.capstone.musicapp.service.UserService;

public class IdRedirectSuccessHandler implements AuthenticationSuccessHandler {

    private final UserService userService;

    public IdRedirectSuccessHandler(UserService userService) {
        this.userService = userService;
    }

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request,
                                        HttpServletResponse response,
                                        Authentication authentication)
            throws IOException, ServletException {

        User userEntity;

        Object principal = authentication.getPrincipal();
        if (principal instanceof UserDetails) {
            // form‐login path
            String email = ((UserDetails) principal).getUsername();
            userEntity = userService.findByEmail(email)
                .orElseThrow(() -> new IllegalStateException("User not found: " + email));

        } else if (principal instanceof OAuth2User) {
            // OAuth2 path
            OAuth2User oauth2User = (OAuth2User) principal;
            String email = oauth2User.getAttribute("email");
            String name  = oauth2User.getAttribute("name");

            Optional<User> opt = userService.findByEmail(email);
            userEntity = opt.orElseGet(() -> userService.createGoogleUser(email, name));

        } else {
            throw new IllegalStateException("Unsupported principal: " + principal.getClass());
        }

        // also set session so root() and other session‐based logic still works
        HttpSession session = request.getSession();
        session.setAttribute("user_id", userEntity.getId());
        session.setAttribute("userName", userEntity.getName());

        // Redirect to /dashboard/{id}
        String target = request.getContextPath() + "/dashboard/" + userEntity.getId();
        response.sendRedirect(target);
    }
}