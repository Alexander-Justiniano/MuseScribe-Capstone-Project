package edu.mdc.capstone.musicapp.controllers;

import java.util.List;
import java.util.Optional;

import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

import edu.mdc.capstone.musicapp.models.LoginUser;
import edu.mdc.capstone.musicapp.models.Notebook;
import edu.mdc.capstone.musicapp.models.User;
import edu.mdc.capstone.musicapp.service.NotebookService;
import edu.mdc.capstone.musicapp.service.UserService;
import edu.mdc.capstone.musicapp.service.UserDetailsServiceImpl;

@Controller
@RequestMapping("/")
public class MainController {

    @Autowired
    private UserService userService;
    
    @Autowired
    private NotebookService notebookService;

    // we need these two to auto-log in upon registration
    @Autowired
    private AuthenticationManager authenticationManager;
    
    @Autowired
    private UserDetailsServiceImpl userDetailsService;
    
// *************************************************************** GET Requests ***************************************************************
    @GetMapping("")
    public String root(HttpSession session) {
        Object uid = session.getAttribute("user_id");
        if(uid != null) {
            return "redirect:/dashboard/" + uid;
        }
        return "redirect:/login";
    }

    @GetMapping("/login")
    public String login() {
        return "MuseScribeLogin.jsp";
    }
    
    @GetMapping("/forgotPassword")
    public String forgotPassword() {
        return "forgotPassword.jsp";
    }
    
    @GetMapping("/register")
    public String register(Model model) {
        model.addAttribute("newUser", new User());
        model.addAttribute("newLogin", new LoginUser());
        return "register.jsp";
    }

    @GetMapping("/dashboard")
    public String dashboardNoId(HttpSession session) {
        return "redirect:/";
    }       


    @GetMapping("/dashboard/{userId}")
    public String dashboardWithId(@PathVariable String userId, Model model) {
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
    
    @GetMapping("/endpoint-test")
    public String testPage() {
        return "endpoint-test.jsp";
    }

// *************************************************************** POST Requests ***************************************************************
    @PostMapping("/register")
    public String register(
            @Valid @ModelAttribute("newUser") User newUser,
            BindingResult result,
            Model model,
            HttpSession session
    ) {
        // try to register; this returns null on error
        User saved = userService.register(newUser, result);
        if(result.hasErrors() || saved == null) {
            model.addAttribute("newLogin", new LoginUser());
            return "register.jsp";
        }

        // — auto-authenticate in Spring Security —
        UserDetails userDetails = userDetailsService.loadUserByUsername(saved.getEmail());
        var authToken = new UsernamePasswordAuthenticationToken(
                userDetails, null, userDetails.getAuthorities());
        SecurityContextHolder.getContext().setAuthentication(authToken);

        // now safe to set our own session attrs and redirect into secured area
        session.setAttribute("user_id", saved.getId());
        session.setAttribute("userName", saved.getName());

        return "redirect:/dashboard/" + saved.getId();
    }

// *************************************************************** PROFILE Route ***************************************************************
    @GetMapping("/profile/{userId}")
    public String userProfile(@PathVariable String userId, Model model) {
        Optional<User> userOpt = userService.getUserById(userId);
        if (userOpt.isEmpty()) {
            return "redirect:/";
        }
        model.addAttribute("user", userOpt.get());
        return "userProfile.jsp";
    }
}