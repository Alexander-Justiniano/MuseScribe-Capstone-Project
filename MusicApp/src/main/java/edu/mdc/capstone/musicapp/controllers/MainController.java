package edu.mdc.capstone.musicapp.controllers;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/")
public class MainController {

	
//	*************************************************************** GET Requests ***************************************************************
	
	@GetMapping("/")
	public String index() {
		return "index.jsp";
	}
	
//	*************************************************************** GET Requests ***************************************************************
}
