package edu.mdc.capstone.musicapp.controllers;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/")
public class MainController {

/*	TODO: 
	
		-Add routes for additional end points
		-Add routes for uploading midi files
		-Secure Routes
		-Work on session information for end user
		 

*/
	
//	*************************************************************** GET Requests ***************************************************************
	
	@GetMapping("/")
	public String index() {
		return "index.jsp";
	}
	
	@GetMapping("/login")
	public String login() {
		return "login.jsp";
	}
	
//	*************************************************************** POST Requests ***************************************************************

		
	@GetMapping("/endpoint-test")
	public String testPage() {
		return "endpoint-test.jsp";
	}
	
//	*************************************************************** GET Requests ***************************************************************

}
