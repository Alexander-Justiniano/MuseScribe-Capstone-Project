package edu.mdc.capstone.musicapp.service;

import edu.mdc.capstone.musicapp.models.User;
import edu.mdc.capstone.musicapp.repositories.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.Optional;
import java.util.Date;

@Service
public class UserService {

	@Autowired
	private UserRepository userRepository;

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
}
