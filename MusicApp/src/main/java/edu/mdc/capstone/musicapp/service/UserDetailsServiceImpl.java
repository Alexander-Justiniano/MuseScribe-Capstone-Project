package edu.mdc.capstone.musicapp.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import edu.mdc.capstone.musicapp.models.User;
import edu.mdc.capstone.musicapp.repositories.UserRepository; // assuming you have a UserRepository
import edu.mdc.capstone.musicapp.security.CustomUserDetails;

@Service
public class UserDetailsServiceImpl implements UserDetailsService {

    @Autowired
    private UserRepository userRepository; 

    @Override
    public UserDetails loadUserByUsername(String email) throws UsernameNotFoundException {
        System.out.println("🔍 Trying to load user: " + email);

        User user = userRepository.findByEmail(email)
            .orElseThrow(() -> {
                System.out.println("🚫 No user found for email: " + email);
                return new UsernameNotFoundException("User not found");
            });

        System.out.println("✅ User found: " + user.getEmail());
        System.out.println("🔐 User password hash: " + user.getPassword());

        return new CustomUserDetails(user);
    }
}