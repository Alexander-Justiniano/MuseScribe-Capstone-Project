package edu.mdc.capstone.musicapp.repositories;

import org.springframework.data.mongodb.repository.MongoRepository;
import edu.mdc.capstone.musicapp.models.Notebook;
import java.util.List;

public interface NotebookRepository extends MongoRepository<Notebook, String> {
     List<Notebook> findByUserId(String userId);
}
