package edu.mdc.capstone.musicapp.service;

import edu.mdc.capstone.musicapp.models.Notebook;
import edu.mdc.capstone.musicapp.models.User;
import edu.mdc.capstone.musicapp.repositories.NotebookRepository;
import edu.mdc.capstone.musicapp.repositories.UserRepository;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Optional;

@Service
public class NotebookService {

    private final NotebookRepository notebookRepository;
    private final UserRepository userRepository;

    public NotebookService(NotebookRepository notebookRepository,
                           UserRepository userRepository) {
        this.notebookRepository = notebookRepository;
        this.userRepository = userRepository;
    }

    /**
     * Create a new Notebook for the given user, persist it, and
     * add its ID to the user's notebookIds list.
     */
    public Notebook createNotebook(String userId, Notebook notebook) {
        // Stamp metadata
        notebook.setUserId(userId);
        notebook.setCreatedAt(new Date());

        // Save notebook
        Notebook saved = notebookRepository.save(notebook);

        // Associate with User
        Optional<User> userOpt = userRepository.findById(userId);
        if (userOpt.isPresent()) {
            User user = userOpt.get();
            if (user.getNotebookIds() == null) {
                user.setNotebookIds(new ArrayList<>());
            }
            user.getNotebookIds().add(saved.getId());
            userRepository.save(user);
        }

        return saved;
    }

    /**
     * Return all notebooks belonging to the given user.
     */
    public List<Notebook> getNotebooksByUser(String userId) {
        return notebookRepository.findByUserId(userId);
    }

    /**
     * Delete the notebook with the given ID, and remove its reference
     * from the owning user's notebookIds list.
     */
    public void deleteNotebook(String notebookId) {
        Optional<Notebook> nbOpt = notebookRepository.findById(notebookId);
        if (nbOpt.isPresent()) {
            Notebook nb = nbOpt.get();
            String userId = nb.getUserId();

            // Remove from user
            Optional<User> userOpt = userRepository.findById(userId);
            if (userOpt.isPresent()) {
                User user = userOpt.get();
                if (user.getNotebookIds() != null) {
                    user.getNotebookIds().remove(notebookId);
                    userRepository.save(user);
                }
            }

            // Finally delete the notebook itself
            notebookRepository.deleteById(notebookId);
        }
    }
}
