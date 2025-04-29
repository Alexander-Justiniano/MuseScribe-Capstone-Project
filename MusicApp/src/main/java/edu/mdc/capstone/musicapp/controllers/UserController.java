package edu.mdc.capstone.musicapp.controllers;

import edu.mdc.capstone.musicapp.models.User;
import edu.mdc.capstone.musicapp.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.Optional;

@RestController
@RequestMapping("/api/users")
public class UserController {

    @Autowired
    private UserService userService;

    

//	*************************************************************** GET Requests ***************************************************************

    
    
    @GetMapping("/{id}")
    public ResponseEntity<?> getUser(@PathVariable String id) {
        Optional<User> user = userService.getUserById(id);
        return user.isPresent() ? ResponseEntity.ok(user.get()) : ResponseEntity.notFound().build();
    }
    

    
//	*************************************************************** POST Requests ***************************************************************

    
    
    @PostMapping
    public ResponseEntity<?> createUser(@RequestBody User user) {
        return ResponseEntity.ok(userService.createUser(user));
    }
    
    

//	*************************************************************** PUT Requests ***************************************************************

    
  
    @PutMapping("/{id}")
    public ResponseEntity<?> updateUser(@PathVariable String id, @RequestBody User user) {
        user.setId(id);
        return ResponseEntity.ok(userService.updateUser(user));
    }
    
    
    
//	*************************************************************** DELETE Requests ***************************************************************

    

    @DeleteMapping("/{id}")
    public ResponseEntity<?> deleteUser(@PathVariable String id) {
        userService.deleteUser(id);
        return ResponseEntity.ok("Deleted successfully");
    }
    
    
    
}
