package edu.mdc.capstone.musicapp.service;

import edu.mdc.capstone.musicapp.models.MusicSheet;
import edu.mdc.capstone.musicapp.models.User;
import edu.mdc.capstone.musicapp.repositories.MusicSheetRepository;
import edu.mdc.capstone.musicapp.repositories.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.*;

@Service
public class MusicSheetService {

    @Autowired
    private MusicSheetRepository musicSheetRepository;

    @Autowired
    private UserRepository userRepository;

    public MusicSheet createMusicSheet(String userId, MusicSheet sheet) {
        sheet.setUserId(userId);
        sheet.setCreatedAt(new Date());
        MusicSheet savedSheet = musicSheetRepository.save(sheet);

        // Associate MusicSheet with User
        User user = userRepository.findById(userId).orElse(null);
        if (user != null) {
            if (user.getMusicSheetIds() == null) {
                user.setMusicSheetIds(new ArrayList<>());
            }
            user.getMusicSheetIds().add(savedSheet.getId());
            userRepository.save(user);
        }
        return savedSheet;
    }

    public List<MusicSheet> getSheetsByUser(String userId) {
        return musicSheetRepository.findByUserId(userId);
    }

    public void deleteMusicSheet(String sheetId) {
        MusicSheet sheet = musicSheetRepository.findById(sheetId).orElse(null);
        if (sheet != null) {
            // Remove from User
            User user = userRepository.findById(sheet.getUserId()).orElse(null);
            if (user != null && user.getMusicSheetIds() != null) {
                user.getMusicSheetIds().remove(sheetId);
                userRepository.save(user);
            }
            musicSheetRepository.deleteById(sheetId);
        }
    }
}
