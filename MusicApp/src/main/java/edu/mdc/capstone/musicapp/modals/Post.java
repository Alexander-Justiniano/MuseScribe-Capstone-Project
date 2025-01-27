package edu.mdc.capstone.musicapp.modals;

import org.bson.types.ObjectId;
import org.bson.codecs.pojo.annotations.BsonId;
import org.bson.codecs.pojo.annotations.BsonProperty;

import java.util.Date;
import java.util.List;

public class Post {
	/*
	 *   
	 * >> Post Fields
	 * 
	 */
	
    @BsonId
    private ObjectId id; // maps to _id

    @BsonProperty("body")
    private String body;

    @BsonProperty("permalink")
    private String permalink;

    @BsonProperty("author")
    private String author;

    @BsonProperty("title")
    private String title;

    @BsonProperty("tags")
    private List<String> tags;

    // Each comment in the array is an object, so we store them in a List<Comment>.
    @BsonProperty("comments")
    private List<Comment> comments;

    // If you also have a date field, include it:
    @BsonProperty("date")
    private Date date; // or Instant, LocalDateTime, etc.

	/*
	 *   
	 * >> Post Methods And Constructors
	 * 
	 */
	
    
    
    public Post() {
    }

    public Post(ObjectId id, String body, String permalink, String author, String title,
                List<String> tags, List<Comment> comments, Date date) {
        this.id = id;
        this.body = body;
        this.permalink = permalink;
        this.author = author;
        this.title = title;
        this.tags = tags;
        this.comments = comments;
        this.date = date;
    }

    // Getters & Setters

    public ObjectId getId() {
        return id;
    }
    public void setId(ObjectId id) {
        this.id = id;
    }

    public String getBody() {
        return body;
    }
    public void setBody(String body) {
        this.body = body;
    }

    public String getPermalink() {
        return permalink;
    }
    public void setPermalink(String permalink) {
        this.permalink = permalink;
    }

    public String getAuthor() {
        return author;
    }
    public void setAuthor(String author) {
        this.author = author;
    }

    public String getTitle() {
        return title;
    }
    public void setTitle(String title) {
        this.title = title;
    }

    public List<String> getTags() {
        return tags;
    }
    public void setTags(List<String> tags) {
        this.tags = tags;
    }

    public List<Comment> getComments() {
        return comments;
    }
    public void setComments(List<Comment> comments) {
        this.comments = comments;
    }

    public Date getDate() {
        return date;
    }
    public void setDate(Date date) {
        this.date = date;
    }
}
