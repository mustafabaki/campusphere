package com.sudobuild.campusphere_backend.student_module.mappers;

import com.sudobuild.campusphere_backend.student_module.DTOs.StudentCreateDTO;
import com.sudobuild.campusphere_backend.student_module.DTOs.StudentResponseDTO;
import com.sudobuild.campusphere_backend.student_module.models.Student;
import org.jetbrains.annotations.NotNull;
import org.springframework.stereotype.Component;

@Component
public class StudentMapper {
    public Student toStudent(@NotNull StudentCreateDTO studentDTO) {
        Student student = new Student();
        student.setName(studentDTO.getName());
        student.setSurname(studentDTO.getSurname());
        student.setEmail(studentDTO.getEmail());
        student.setPhone(studentDTO.getPhone());
        student.setDepartment(studentDTO.getDepartment());
        student.setProfilePictureURL(studentDTO.getProfilePictureURL());
        return student;
    }

    public StudentResponseDTO toStudentResponseDTO(@NotNull Student student) {
        StudentResponseDTO studentResponseDTO = new StudentResponseDTO();
        studentResponseDTO.setId(student.getId());
        studentResponseDTO.setName(student.getName());
        studentResponseDTO.setSurname(student.getSurname());
        studentResponseDTO.setEmail(student.getEmail());
        studentResponseDTO.setPhone(student.getPhone());
        studentResponseDTO.setProfilePictureURL(student.getProfilePictureURL());
        studentResponseDTO.setEnrolledClubs(student.getEnrolledClubs());
        studentResponseDTO.setSocialLinks(student.getSocialLinks());
        studentResponseDTO.setDepartment(student.getDepartment());
        return studentResponseDTO;
    }
}
