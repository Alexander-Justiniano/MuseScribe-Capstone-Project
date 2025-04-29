package edu.mdc.capstone.musicapp.controllers;

import edu.mdc.capstone.musicapp.models.MusicSheet;
import edu.mdc.capstone.musicapp.service.MusicSheetService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/music-sheets")
public class MusicSheetController {

	@Autowired
	private MusicSheetService musicSheetService;

	
	
//	*************************************************************** GET Requests ***************************************************************

	
	
	@GetMapping("/{notebookId}")
	public ResponseEntity<?> getSheetsByUser(@PathVariable String notebookId) {
		List<MusicSheet> sheets = musicSheetService.getSheetsByNotebook(notebookId);
		return ResponseEntity.ok(sheets);
	}
	
	
   
//	*************************************************************** POST Requests ***************************************************************

    
    
    @PostMapping("/{notebookId}")
	public ResponseEntity<?> addSheet(@PathVariable String notebookId, @RequestBody MusicSheet sheet) {
		return ResponseEntity.ok(musicSheetService.createMusicSheet(notebookId, sheet));
	}

    

//	*************************************************************** PUT Requests ***************************************************************

    
    
    // new update
    @PutMapping("/{sheetId}")
    public ResponseEntity<MusicSheet> updateSheet(
            @PathVariable String sheetId,
            @RequestBody MusicSheet sheet
    ) {
        // ensure the incoming POJO has the correct ID
        sheet.setId(sheetId);
        MusicSheet updated = musicSheetService.updateMusicSheet(sheet);
        return ResponseEntity.ok(updated);
    }
    
    
    
//	*************************************************************** DELETE Requests ***************************************************************

    

	@DeleteMapping("/{sheetId}")
	public ResponseEntity<?> deleteSheet(@PathVariable String sheetId) {
		musicSheetService.deleteMusicSheet(sheetId);
		return ResponseEntity.ok("Deleted successfully");
	}
	
	
	
}
