package com.sudobuild.campusphere_backend.student_module.repositories;

import com.sudobuild.campusphere_backend.student_module.models.Student;
import org.springframework.data.jpa.repository.JpaRepository;

public interface StudentRepository extends JpaRepository<Student, String> {
    Student findStudentByEmail(String email);
}