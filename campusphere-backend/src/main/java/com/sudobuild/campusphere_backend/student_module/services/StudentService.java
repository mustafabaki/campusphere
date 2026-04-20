package com.sudobuild.campusphere_backend.student_module.services;

import com.sudobuild.campusphere_backend.student_module.DTOs.StudentCreateDTO;
import com.sudobuild.campusphere_backend.student_module.DTOs.StudentResponseDTO;
import com.sudobuild.campusphere_backend.student_module.models.Student;
import org.springframework.stereotype.Service;


public interface StudentService {
    StudentResponseDTO create(StudentCreateDTO student);

    StudentResponseDTO getStudentByEmail(String email);

    void deleteStudent(String id);

    StudentResponseDTO updateStudent(String id, StudentCreateDTO student);

}
