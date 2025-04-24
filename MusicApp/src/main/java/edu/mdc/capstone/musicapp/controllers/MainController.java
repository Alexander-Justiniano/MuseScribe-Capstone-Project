package edu.mdc.capstone.musicapp.controllers;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import edu.mdc.capstone.musicapp.models.Notebook;
import edu.mdc.capstone.musicapp.models.User;
import edu.mdc.capstone.musicapp.service.UserService;
import edu.mdc.capstone.musicapp.service.NotebookService;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;

@Controller
@RequestMapping("/")
public class MainController {

	/*
	 * TODO:
	 * 
	 * -Add routes for additional end points -Add routes for uploading midi files
	 * -Secure Routes -Work on session information for end user
	 * 
	 * 
	 */

//	*************************************************************** GET Requests ***************************************************************


	@GetMapping("")
	public String login() {
		return "MuseScribeLogin.jsp";
	}

	@GetMapping("/dashboard")
	public String index() {
		return "index.jsp";
	}

//	*************************************************************** POST Requests ***************************************************************

	@GetMapping("/endpoint-test")
	public String testPage() {
		return "endpoint-test.jsp";
	}

//	*************************************************************** GET Requests ***************************************************************

	@Autowired
	private UserService userService;
	
	@Autowired
    private NotebookService notebookService;

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

}
