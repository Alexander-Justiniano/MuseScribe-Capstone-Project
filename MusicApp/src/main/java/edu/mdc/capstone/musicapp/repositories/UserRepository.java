package edu.mdc.capstone.musicapp.repositories;

import org.springframework.data.mongodb.repository.MongoRepository;
import edu.mdc.capstone.musicapp.models.User;

public interface UserRepository extends MongoRepository<User, String> {
    User findByGoogleId(String googleId);
}
