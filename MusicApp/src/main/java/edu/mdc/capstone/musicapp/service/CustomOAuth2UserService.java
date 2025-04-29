package edu.mdc.capstone.musicapp.service;

import java.util.Map;
import java.util.Optional;

import org.springframework.security.oauth2.client.userinfo.DefaultOAuth2UserService;
import org.springframework.security.oauth2.client.userinfo.OAuth2UserRequest;
import org.springframework.security.oauth2.core.OAuth2AuthenticationException;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.stereotype.Service;

import edu.mdc.capstone.musicapp.models.User;
import edu.mdc.capstone.musicapp.repositories.UserRepository;

@Service
public class CustomOAuth2UserService extends DefaultOAuth2UserService {

    private final UserRepository userRepository;

    public CustomOAuth2UserService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    @Override
    public OAuth2User loadUser(OAuth2UserRequest userRequest)
            throws OAuth2AuthenticationException {

        // Delegate to the default implementation for fetching user info
        OAuth2User oauthUser = super.loadUser(userRequest);
        Map<String, Object> attrs = oauthUser.getAttributes();

        // Google returns the unique ID under "sub"
        String googleId = attrs.get("sub").toString();
        String email    = attrs.get("email").toString();
        String name     = attrs.get("name").toString();

        // Look up (or create) our app’s User
        Optional<User> existing = userRepository.findByGoogleId(googleId);
        if (existing.isEmpty()) {
            User newUser = new User();
            newUser.setGoogleId(googleId);
            newUser.setEmail(email);
            newUser.setName(name);
            userRepository.save(newUser);
        }

        // Return the OAuth2User back to Spring Security
        return oauthUser;
    }
}