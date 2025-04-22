package edu.mdc.capstone.musicapp.controllers;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import edu.mdc.capstone.musicapp.models.User;
import edu.mdc.capstone.musicapp.service.UserService;
import edu.mdc.capstone.musicapp.service.MusicSheetService;
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
	private MusicSheetService musicSheetService;


	@GetMapping("/{userId}")
	public String userHome(@PathVariable String userId, Model model) {
		// Fetch user info
		User user = userService.getUserById(userId).orElse(null);

		if (user != null) {
			model.addAttribute("user", user);
			model.addAttribute("musicSheets", musicSheetService.getSheetsByUser(userId));
		} else {
			model.addAttribute("error", "User not found");
		}

		return "index.jsp";
	}

}
