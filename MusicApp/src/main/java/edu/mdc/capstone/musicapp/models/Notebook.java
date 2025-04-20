package edu.mdc.capstone.musicapp.models;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import java.util.Date;
import java.util.List;

/**
 * A Notebook groups together multiple MusicSheets for a given user.
 */
@Document(collection = "notebooks")
public class Notebook {

    @Id
    private String id;

    /** Owner of this notebook */
    private String userId;

    /** title for this notebook */
    private String title;

    /** References to MusicSheet IDs contained in this notebook */
    private List<String> musicSheetIds;

    /** Timestamp for creation **/
    private Date createdAt;

    public Notebook() {}

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

    public List<String> getMusicSheetIds() {
        return musicSheetIds;
    }

    public void setMusicSheetIds(List<String> musicSheetIds) {
        this.musicSheetIds = musicSheetIds;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }
}
