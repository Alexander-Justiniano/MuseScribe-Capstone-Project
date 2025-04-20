package edu.mdc.capstone.musicapp.models;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import java.util.Date;
import java.util.List;

/**
 * A User can own multiple Notebooks, each of which groups MusicSheets.
 */
@Document(collection = "users")
public class User {
    @Id
    private String id;
    private String googleId;
    private String email;
    private String name;

    /** When the user was first created */
    private Date createdAt;

    /**
     * References to Notebook IDs that belong to this user.
     * Each Notebook in turn holds its own list of MusicSheet IDs.
     */
    private List<String> notebookIds;

    public User() {}

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getGoogleId() {
        return googleId;
    }

    public void setGoogleId(String googleId) {
        this.googleId = googleId;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public List<String> getNotebookIds() {
        return notebookIds;
    }

    public void setNotebookIds(List<String> notebookIds) {
        this.notebookIds = notebookIds;
    }
}
