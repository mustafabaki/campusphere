package com.sudobuild.campusphere_backend.student_module.services.implementations;

import com.sudobuild.campusphere_backend.student_module.models.Student;
import com.sudobuild.campusphere_backend.student_module.repositories.SocialLinkRepository;
import com.sudobuild.campusphere_backend.student_module.repositories.StudentClubRepository;
import com.sudobuild.campusphere_backend.student_module.repositories.StudentRepository;
import com.sudobuild.campusphere_backend.student_module.services.StudentService;
import org.springframework.stereotype.Service;

@Service
public class StudentServiceImpl implements StudentService {
    private final StudentRepository studentRepository;
    private final StudentClubRepository studentClubRepository;
    private final SocialLinkRepository socialLinkRepository;


    public StudentServiceImpl(StudentRepository studentRepository, StudentClubRepository studentClubRepository, SocialLinkRepository socialLinkRepository) {
        this.studentRepository = studentRepository;
        this.studentClubRepository = studentClubRepository;
        this.socialLinkRepository = socialLinkRepository;
    }


    @Override
    public Student create(Student student) {
        try {
            return studentRepository.save(student);
        } catch (Exception e) {
            return null;
        }
    }
}
