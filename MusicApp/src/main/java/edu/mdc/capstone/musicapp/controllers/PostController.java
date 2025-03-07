package edu.mdc.capstone.musicapp.controllers;

import edu.mdc.capstone.musicapp.models.Post;
import edu.mdc.capstone.musicapp.service.PostService;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * Handles HTTP requests for posts.
 */
@RestController
public class PostController {

    private final PostService postService;

    // Constructor-based injection
    public PostController(PostService postService) {
        this.postService = postService;
    }

    // GET /posts -> Returns all posts
    @GetMapping("/posts")
    public List<Post> getAllPosts() {
        return postService.findAllPosts();
    }

    // Example: GET /posts/{id} -> Returns a single post by ID
    @GetMapping("/posts/{id}")
    public Post getPostById(@PathVariable String id) {
        return postService.findPostById(id);
    }
}
