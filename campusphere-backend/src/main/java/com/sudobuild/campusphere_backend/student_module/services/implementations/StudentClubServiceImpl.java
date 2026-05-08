package com.sudobuild.campusphere_backend.student_module.services.implementations;

import java.util.List;

import com.sudobuild.campusphere_backend.student_module.models.StudentClub;
import com.sudobuild.campusphere_backend.student_module.repositories.StudentClubRepository;
import com.sudobuild.campusphere_backend.student_module.services.StudentClubService;

import org.springframework.stereotype.Service;

@Service
public class StudentClubServiceImpl implements StudentClubService {
    private final StudentClubRepository studentClubRepository;

    public StudentClubServiceImpl(StudentClubRepository studentClubRepository) {
        this.studentClubRepository = studentClubRepository;
    }

    @Override
    public StudentClub create(StudentClub studentClub) {
        try {
            return studentClubRepository.save(studentClub);
        } catch (Exception e) {
            throw new RuntimeException("Club cannot be created.");
        }
    }

    @Override
    public StudentClub update(String id, StudentClub studentClub) {
        try {
            StudentClub existingClub = studentClubRepository.findById(id)
                    .orElseThrow(() -> new RuntimeException("Club not found with id: " + id));

            // Update fields if not null
            if(studentClub.getName() != null) {
                existingClub.setName(studentClub.getName());
            }
            if(studentClub.getDescription() != null) {
                existingClub.setDescription(studentClub.getDescription());
            }
            if(studentClub.getLogoURL() != null) {
                existingClub.setLogoURL(studentClub.getLogoURL());
            }

            return studentClubRepository.save(existingClub);

        } catch (Exception e) {
            throw new RuntimeException("Club cannot be updated.");
        }
    }

    @Override
    public void delete(String id) {
        try {
            StudentClub existingClub = studentClubRepository.findById(id)
                    .orElseThrow(() -> new RuntimeException("Club not found with id: " + id));
            studentClubRepository.delete(existingClub);
        } catch (Exception e) {
            throw new RuntimeException("Club cannot be deleted.");
        }
    }

    @Override
    public StudentClub getById(String id) {
        try {
            return studentClubRepository.findById(id)
                    .orElseThrow(() -> new RuntimeException("Club not found with id: " + id));
        } catch (Exception e) {
            throw new RuntimeException("Club cannot be found.");
        }
    }

    @Override
    public List<StudentClub> getAll() {
        try {
            return studentClubRepository.findAll();
        } catch (Exception e) {
            throw new RuntimeException("Clubs cannot be retrieved.");
        }
    }

}
