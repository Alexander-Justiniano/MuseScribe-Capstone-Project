package edu.mdc.capstone.musicapp.controllers;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import edu.mdc.capstone.musicapp.models.LoginUser;
import edu.mdc.capstone.musicapp.models.Notebook;
import edu.mdc.capstone.musicapp.models.User;
import edu.mdc.capstone.musicapp.service.NotebookService;
import edu.mdc.capstone.musicapp.service.UserService;
import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;

@Controller
@RequestMapping("/")
public class MainController {

	@Autowired
	private UserService userService;
	
	@Autowired
    private NotebookService notebookService;
	
//	*************************************************************** GET Requests ***************************************************************


	@GetMapping("/")
	public String login() {
		return "MuseScribeLogin.jsp";
	}
	
	@GetMapping("/register")
	public String register(Model model) {
		model.addAttribute("newUser", new User());
		model.addAttribute("newLogin", new LoginUser());
		return "register.jsp";
	}

	@GetMapping("/dashboard")
	public String index() {
		return "MuseScribeLogin.jsp";
	}
	
	@GetMapping("/endpoint-test")
	public String testPage() {
		return "endpoint-test.jsp";
	}
	
	 @GetMapping("/dashboard/{userId}")
	    public String userHome(@PathVariable String userId, Model model) {
	        Optional<User> userOpt = userService.getUserById(userId);
	        if (userOpt.isEmpty()) {
	            model.addAttribute("error", "User not found");
	            return "index.jsp";
	        }
	        
	        

	        User user = userOpt.get();
	        model.addAttribute("user", user);

	        List<Notebook> notebooks = notebookService.getNotebooksByUser(userId);
	        model.addAttribute("notebooks", notebooks);

	        return "index.jsp";
	    }

	

//	*************************************************************** POST Requests ***************************************************************

	
	@PostMapping("/register")
	public String register(@Valid @ModelAttribute("newUser") User newUser, 
            BindingResult result, Model model, HttpSession session) {

//		Make call to the user service to register the new user

		userService.register(newUser, result);
        
        if(result.hasErrors()) {
        	model.addAttribute("newLogin", new LoginUser());
            return "register.jsp";
        }
        
        session.setAttribute("user_id", newUser.getId());
        session.setAttribute("userName", newUser.getName());
    
        return "redirect:/dashboard";
    }    

}
