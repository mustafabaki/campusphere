package com.sudobuild.campusphere_backend.student_module.services;

import com.sudobuild.campusphere_backend.student_module.models.Student;
import org.springframework.stereotype.Service;


public interface StudentService {
    Student create(Student student);
}
