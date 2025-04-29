package edu.mdc.capstone.musicapp.controllers;

import edu.mdc.capstone.musicapp.models.MusicSheet;
import edu.mdc.capstone.musicapp.models.Notebook;
import edu.mdc.capstone.musicapp.service.MusicSheetService;
import edu.mdc.capstone.musicapp.service.NotebookService;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/notebooks")
public class NotebookController {

    private final NotebookService   notebookService;
    private final MusicSheetService musicSheetService;
    
    public NotebookController(NotebookService notebookService,
                              MusicSheetService musicSheetService) {
        this.notebookService   = notebookService;
        this.musicSheetService = musicSheetService;
    }
    
    
    
//	*************************************************************** GET Requests ***************************************************************

    
    
    /**
     * List all Notebooks belonging to a user.
     * GET /api/notebooks/{userId}
     */
    @GetMapping("/{userId}")
    public ResponseEntity<List<Notebook>> getNotebooksByUser(
            @PathVariable String userId
    ) {
        List<Notebook> notebooks = notebookService.getNotebooksByUser(userId);
        return ResponseEntity.ok(notebooks);
    }

    /**
     * Return all MusicSheets in the given notebook.
     * GET /api/notebooks/{notebookId}/sheets
     */
    @GetMapping("/{notebookId}/sheets")
    public ResponseEntity<List<MusicSheet>> getSheetsByNotebook(
            @PathVariable String notebookId
    ) {
        List<MusicSheet> sheets = musicSheetService.getSheetsByNotebook(notebookId);
        return ResponseEntity.ok(sheets);
    }
    
    
    
//	*************************************************************** POST Requests ***************************************************************


    
    /**
     * Create a new Notebook for the given user.
     * POST /api/notebooks/{userId}
     */
    @PostMapping("/{userId}")
    public ResponseEntity<Notebook> createNotebook(
            @PathVariable String userId,
            @RequestBody Notebook notebook
    ) {
        Notebook created = notebookService.createNotebook(userId, notebook);
        return ResponseEntity.ok(created);
    }
    
    
    
//	*************************************************************** DELETE Requests ***************************************************************


    /**
     * Delete a Notebook (and optionally all sheets inside it).
     * DELETE /api/notebooks/{notebookId}
     */
    @DeleteMapping("/{notebookId}")
    public ResponseEntity<?> deleteNotebook(
            @PathVariable String notebookId
    ) {
        notebookService.deleteNotebook(notebookId);
        return ResponseEntity.ok("Notebook deleted");
    }
}
