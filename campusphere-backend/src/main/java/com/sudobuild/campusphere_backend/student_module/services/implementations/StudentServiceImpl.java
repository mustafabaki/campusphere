package com.sudobuild.campusphere_backend.student_module.services.implementations;

import com.sudobuild.campusphere_backend.student_module.DTOs.StudentCreateDTO;
import com.sudobuild.campusphere_backend.student_module.DTOs.StudentResponseDTO;
import com.sudobuild.campusphere_backend.student_module.mappers.StudentMapper;
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
    private final StudentMapper studentMapper;


    public StudentServiceImpl(StudentRepository studentRepository, StudentClubRepository studentClubRepository, SocialLinkRepository socialLinkRepository, StudentMapper studentMapper) {
        this.studentRepository = studentRepository;
        this.studentClubRepository = studentClubRepository;
        this.socialLinkRepository = socialLinkRepository;
        this.studentMapper = studentMapper;
    }


    @Override
    public StudentResponseDTO create(StudentCreateDTO student) {
        var studentToSave = studentMapper.toStudent(student);
        var savedStudent = studentRepository.save(studentToSave);
        return studentMapper.toStudentResponseDTO(savedStudent);
    }
}
