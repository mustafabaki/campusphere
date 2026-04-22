package com.sudobuild.campusphere_backend.student_module.services.implementations;

import com.sudobuild.campusphere_backend.student_module.DTOs.StudentCreateDTO;
import com.sudobuild.campusphere_backend.student_module.DTOs.StudentResponseDTO;
import com.sudobuild.campusphere_backend.student_module.enums.SocialMediaPlatform;
import com.sudobuild.campusphere_backend.student_module.mappers.StudentMapper;
import com.sudobuild.campusphere_backend.student_module.models.SocialLink;
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

    @Override
    public StudentResponseDTO getStudentByEmail(String email) {
        Student student = studentRepository.findStudentByEmail(email);
        return studentMapper.toStudentResponseDTO(student);
    }

    @Override
    public void deleteStudent(String id) {
        studentRepository.deleteById(id);
    }

    @Override
    public StudentResponseDTO updateStudent(String id, StudentCreateDTO student) {
        // fetch the existing student
        Student existingStudent = studentRepository.findById(id).orElseThrow(() -> new RuntimeException("Student not found with id: " + id));

        // update the fields of the existing student with the new values from the DTO (only if they are not null)
        if (student.getName() != null) {
            existingStudent.setName(student.getName());
        }
        if (student.getSurname() != null) {
            existingStudent.setSurname(student.getSurname());
        }
        if (student.getEmail() != null) {
            existingStudent.setEmail(student.getEmail());
        }
        if (student.getPhone() != null) {
            existingStudent.setPhone(student.getPhone());
        }
        if (student.getProfilePictureURL() != null) {
            existingStudent.setProfilePictureURL(student.getProfilePictureURL());
        }
        if (student.getDepartment() != null) {
            existingStudent.setDepartment(student.getDepartment());
        }

        // save the updated student
        Student updatedStudent = studentRepository.save(existingStudent);
        return studentMapper.toStudentResponseDTO(updatedStudent);

    }

    @Override
    public StudentResponseDTO addSocialLinkToStudent(String studentId, String url, SocialMediaPlatform platform) {
        // find the student
        Student student = studentRepository.findById(studentId).orElseThrow(() -> new RuntimeException("Student not found with id: " + studentId));

        // create the social link
        SocialLink socialLink = new SocialLink();
        socialLink.setUrl(url);
        socialLink.setPlatform(platform);
        socialLink.setStudent(student);

        // save the social link
        socialLinkRepository.save(socialLink);

        // return the updated student
        return studentMapper.toStudentResponseDTO(student);
    }
}
