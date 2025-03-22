package edu.mdc.capstone.musicapp.models;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import java.util.Date;

@Document(collection = "musicSheets")
public class MusicSheet {
	@Id
	private String id;
	private String userId; // References User
	private String title;
	private String abcNotation;
	private Date createdAt;

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getAbcNotation() {
		return abcNotation;
	}

	public void setAbcNotation(String abcNotation) {
		this.abcNotation = abcNotation;
	}

	public Date getCreatedAt() {
		return createdAt;
	}

	public void setCreatedAt(Date createdAt) {
		this.createdAt = createdAt;
	}

}