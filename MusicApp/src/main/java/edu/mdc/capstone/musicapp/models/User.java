package edu.mdc.capstone.musicapp.models;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import java.util.Date;
import java.util.List;

@Document(collection = "users")
public class User {
	@Id
	private String id;
	private String googleId;
	private String email;
	private String name;
	private Date createdAt;
	private List<String> musicSheetIds; // List of MusicSheet IDs

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

	public List<String> getMusicSheetIds() {
		return musicSheetIds;
	}

	public void setMusicSheetIds(List<String> musicSheetIds) {
		this.musicSheetIds = musicSheetIds;
	}

	// Getters and Setters

}