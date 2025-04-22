package edu.mdc.capstone.musicapp.repositories;

import org.springframework.data.mongodb.repository.MongoRepository;
import edu.mdc.capstone.musicapp.models.MusicSheet;
import java.util.List;

public interface MusicSheetRepository extends MongoRepository<MusicSheet, String> {
    List<MusicSheet> findByUserId(String userId);
}
