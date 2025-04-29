package edu.mdc.capstone.musicapp.models;

import java.util.Date;
import java.util.List;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import jakarta.persistence.Transient;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

/**
 * A User can own multiple Notebooks, each of which groups MusicSheets.
 */
@Document(collection = "users")
public class User {
	
    @Id
    private String id;
    
    private String googleId;
    
    @NotBlank(message="Email is required!")
    @Email(message="Please enter a valid email")
    private String email;
    
    @NotBlank(message="Name is required!")
    @Size(min=1, max=30, message="Name must be between 1 and 30 characters")
    private String name;
    
    @NotBlank(message="Password is required!")
    @Size(min=8, max=128, message="Password must be between 8 and 128 characters")
    private String password;
    
    @Transient
    @NotBlank(message="Confirm Password is required!")
    @Size(min=8, max=128, message="Confirm Password must be between 8 and 128 characters")
    private String confirm;

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
    
    public String getPassword() {
    	return password;
    }
    
    public void setPassword(String password) {
    	this.password = password;
    }
    
    public String getConfirm() {
		return confirm;
	}

	public void setConfirm(String confirm) {
		this.confirm = confirm;
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
