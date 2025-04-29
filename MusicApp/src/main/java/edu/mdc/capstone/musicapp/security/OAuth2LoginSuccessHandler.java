package edu.mdc.capstone.musicapp.security;

import java.io.IOException;
import java.util.Map;

import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.stereotype.Component;

import edu.mdc.capstone.musicapp.models.User;
import edu.mdc.capstone.musicapp.service.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@Component
public class OAuth2LoginSuccessHandler implements AuthenticationSuccessHandler {

    private final UserService userService;

    public OAuth2LoginSuccessHandler(UserService userService) {
        this.userService = userService;
    }

    /**
     * After Google login, either find() or createGoogleUser(), then redirect
     * to /dashboard/{userId}.
     */
    @Override
    public void onAuthenticationSuccess(
            HttpServletRequest request,
            HttpServletResponse response,
            Authentication authentication
    ) throws IOException, ServletException {
        // The Google‐provided user
        @SuppressWarnings("unchecked")
        Map<String,Object> attrs = ((org.springframework.security.oauth2.core.user.OAuth2User)
                                     authentication.getPrincipal())
                                    .getAttributes();

        String email = (String) attrs.get("email");
        String name  = (String) attrs.get("name");

        // lookup or bootstrap
        User user = userService.findByEmail(email)
                     .orElseGet(() -> userService.createGoogleUser(email, name));

        // now redirect
        response.sendRedirect(request.getContextPath() + "/dashboard/" + user.getId());
    }
}