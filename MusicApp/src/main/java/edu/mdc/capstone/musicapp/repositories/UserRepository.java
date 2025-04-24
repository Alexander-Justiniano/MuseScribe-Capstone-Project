package edu.mdc.capstone.musicapp.repositories;

import java.util.List;
import java.util.Optional;

import org.springframework.data.mongodb.repository.MongoRepository;

import edu.mdc.capstone.musicapp.models.User;

public interface UserRepository extends MongoRepository<User, String> {
    User findByGoogleId(String googleId);
    
	List<User> findAll();
	
	Optional<User> findByEmail(String email);
	
	User findUserByEmail(String email);

}
