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

    @PostMapping("/{userId}")
    public ResponseEntity<?> addSheet(@PathVariable String userId, @RequestBody MusicSheet sheet) {
        return ResponseEntity.ok(musicSheetService.createMusicSheet(userId, sheet));
    }

    @GetMapping("/{userId}")
    public ResponseEntity<?> getSheetsByUser(@PathVariable String userId) {
        List<MusicSheet> sheets = musicSheetService.getSheetsByUser(userId);
        return ResponseEntity.ok(sheets);
    }

    @DeleteMapping("/{sheetId}")
    public ResponseEntity<?> deleteSheet(@PathVariable String sheetId) {
        musicSheetService.deleteMusicSheet(sheetId);
        return ResponseEntity.ok("Deleted successfully");
    }
}
