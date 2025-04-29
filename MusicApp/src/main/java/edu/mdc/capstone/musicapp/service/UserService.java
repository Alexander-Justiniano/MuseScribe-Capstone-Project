package edu.mdc.capstone.musicapp.service;

import java.util.Date;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCrypt;
import org.springframework.stereotype.Service;
import org.springframework.validation.BindingResult;

import edu.mdc.capstone.musicapp.models.User;
import edu.mdc.capstone.musicapp.repositories.UserRepository;

@Service
public class UserService {

    @Autowired
    private UserRepository userRepository;

    //
    // Registration of local users
    public User register(User newUser, BindingResult result) {
        // Reject if password doesn't match confirmation
        if(!newUser.getPassword().equals(newUser.getConfirm())) {
            result.rejectValue("confirm", "Matches", "The Confirm Password must match Password!");    	
        }

        // Reject if email is taken (present in database)
        Optional<User> potentialUser = userRepository.findByEmail(newUser.getEmail());
        if(potentialUser.isPresent()){
            result.rejectValue("email", "Duplicate", "This email is already registered!");
        }

        // Return null if result has errors
        if(result.hasErrors()) {
            return null;
        }

        // Hash and set password, save user to database
        String hashed = BCrypt.hashpw(newUser.getPassword(), BCrypt.gensalt());
        newUser.setPassword(hashed);
        return userRepository.save(newUser);
    }

    //
    // Basic CRUD for User
    public User createUser(User user) {
        user.setCreatedAt(new Date());
        return userRepository.save(user);
    }

    public Optional<User> getUserById(String id) {
        return userRepository.findById(id);
    }

    public User updateUser(User user) {
        return userRepository.save(user);
    }

    public void deleteUser(String id) {
        userRepository.deleteById(id);
    }

    //
    // ————————————————
    // OAuth2 helper methods
    // ————————————————

    /**
     * Look up a User by email.
     */
    public Optional<User> findByEmail(String email) {
        return userRepository.findByEmail(email);
    }

    /**
     * Create a brand-new User after Google login.
     * We only know their email & name; we set a dummy password.
     */
    public User createGoogleUser(String email, String name) {
        User user = new User();
        user.setEmail(email);
        user.setName(name);
        // no local password
        user.setPassword(""); 
        user.setCreatedAt(new Date());
        return userRepository.save(user);
    }
}