package edu.mdc.capstone.musicapp.models;

import org.bson.codecs.pojo.annotations.BsonProperty;

public class Comment {
    
    @BsonProperty("body")
    private String body;

    @BsonProperty("email")
    private String email;

    @BsonProperty("author")
    private String author;

    // Constructors (no-args constructor is required for POJO mapping)
    public Comment() {
    }

    public Comment(String body, String email, String author) {
        this.body = body;
        this.email = email;
        this.author = author;
    }

    // Getters and setters
    public String getBody() {
        return body;
    }
    public void setBody(String body) {
        this.body = body;
    }

    public String getEmail() {
        return email;
    }
    public void setEmail(String email) {
        this.email = email;
    }

    public String getAuthor() {
        return author;
    }
    public void setAuthor(String author) {
        this.author = author;
    }
}
