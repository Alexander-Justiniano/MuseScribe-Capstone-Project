package edu.mdc.capstone.musicapp.service;

import edu.mdc.capstone.musicapp.models.MusicSheet;
import edu.mdc.capstone.musicapp.models.Notebook;
import edu.mdc.capstone.musicapp.repositories.MusicSheetRepository;
import edu.mdc.capstone.musicapp.repositories.NotebookRepository;
import org.springframework.stereotype.Service;

import java.util.*;

@Service
public class MusicSheetService {

    private final MusicSheetRepository musicSheetRepository;
    private final NotebookRepository notebookRepository;

    public MusicSheetService(MusicSheetRepository musicSheetRepository,
                             NotebookRepository notebookRepository) {
        this.musicSheetRepository = musicSheetRepository;
        this.notebookRepository = notebookRepository;
    }

    /**
     * Creates a new MusicSheet under the given notebook.
     * @param notebookId ID of the notebook to which this sheet belongs.
     * @param sheet      The MusicSheet object (title + ABC notation).
     * @return           The saved MusicSheet, with generated ID.
     */
    public MusicSheet createMusicSheet(String notebookId, MusicSheet sheet) {
        // 1) Stamp metadata
        sheet.setNotebookId(notebookId);
        sheet.setCreatedAt(new Date());

        // 2) Persist sheet
        MusicSheet savedSheet = musicSheetRepository.save(sheet);

        // 3) Add sheet ID to notebook
        Optional<Notebook> nbOpt = notebookRepository.findById(notebookId);
        if (nbOpt.isPresent()) {
            Notebook nb = nbOpt.get();
            if (nb.getMusicSheetIds() == null) {
                nb.setMusicSheetIds(new ArrayList<>());
            }
            nb.getMusicSheetIds().add(savedSheet.getId());
            notebookRepository.save(nb);
        } else {
            // (Optionally) roll back or throw if notebook not found
        }

        return savedSheet;
    }

    /**
     * Retrieves all MusicSheets within a notebook.
     * @param notebookId ID of the notebook.
     * @return List of MusicSheets in that notebook.
     */
    public List<MusicSheet> getSheetsByNotebook(String notebookId) {
        return notebookRepository.findById(notebookId)
          .map(nb -> {
            List<String> ids = nb.getMusicSheetIds();
            return (ids == null || ids.isEmpty())
              ? Collections.<MusicSheet>emptyList()
              : musicSheetRepository.findAllById(ids);  // returns List<MusicSheet>
          })
          .orElse(Collections.emptyList());
    }    

    /**
     * Updates an existing MusicSheet's title and notation.
     */
    public MusicSheet updateMusicSheet(MusicSheet updatedSheet) {
        return musicSheetRepository.findById(updatedSheet.getId())
            .map(existing -> {
                existing.setTitle(updatedSheet.getTitle());
                existing.setAbcNotation(updatedSheet.getAbcNotation());
                existing.setUpdatedAt(new Date());
                return musicSheetRepository.save(existing);
            })
            .orElseThrow(() -> new NoSuchElementException(
                "MusicSheet not found: " + updatedSheet.getId()
            ));
    }

    
    /**
     * Deletes a MusicSheet and removes its reference from its parent notebook.
     * @param sheetId ID of the sheet to delete.
     */
    public void deleteMusicSheet(String sheetId) {
        Optional<MusicSheet> sheetOpt = musicSheetRepository.findById(sheetId);
        if (sheetOpt.isPresent()) {
            String notebookId = sheetOpt.get().getNotebookId();

            // 1) Remove from notebook
            Optional<Notebook> nbOpt = notebookRepository.findById(notebookId);
            if (nbOpt.isPresent()) {
                Notebook nb = nbOpt.get();
                if (nb.getMusicSheetIds() != null) {
                    nb.getMusicSheetIds().remove(sheetId);
                    notebookRepository.save(nb);
                }
            }

            // 2) Delete sheet itself
            musicSheetRepository.deleteById(sheetId);
        }
    }
}
