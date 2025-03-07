package edu.mdc.capstone.musicapp.service;

import com.mongodb.client.MongoClient;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;

import edu.mdc.capstone.musicapp.models.Post;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

/**
 * Handles data access for Post documents.
 */
@Service
public class PostService {

    @Value("${spring.data.mongodb.database}")
    private String databaseName;

    // The MongoClient is injected from MongoConfig
    private final MongoClient mongoClient;

    public PostService(MongoClient mongoClient) {
        this.mongoClient = mongoClient;
    }

    public List<Post> findAllPosts() {
        MongoDatabase database = mongoClient.getDatabase(databaseName);
        MongoCollection<Post> collection = database.getCollection("posts", Post.class);

        List<Post> posts = new ArrayList<>();
        collection.find().into(posts);
        return posts;
    }

    // Example method if you need to find by ID, insert, etc.
    public Post findPostById(String id) {
        MongoDatabase database = mongoClient.getDatabase(databaseName);
        MongoCollection<Post> collection = database.getCollection("posts", Post.class);

        // Convert string to ObjectId, if needed
        // (Error handling omitted for brevity)
        return collection.find(org.bson.Document.parse("{_id: {$oid: \"" + id + "\"}}")).first();
    }
}
