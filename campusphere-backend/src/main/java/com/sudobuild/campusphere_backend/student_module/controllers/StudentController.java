package com.sudobuild.campusphere_backend.student_module.controllers;

import com.sudobuild.campusphere_backend.auxiliary.ApiResponse;
import com.sudobuild.campusphere_backend.student_module.DTOs.StudentCreateDTO;
import com.sudobuild.campusphere_backend.student_module.services.StudentService;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("api/student")
public class StudentController {
    private final StudentService studentService;

    public StudentController(StudentService studentService) {
        this.studentService = studentService;
    }

    @PostMapping("/create")
    public ApiResponse<?> createStudent(@RequestBody StudentCreateDTO student) {
        try {
            var savedStudent = studentService.create(student);
            return ApiResponse.success(savedStudent);
        } catch (Exception e) {
            return ApiResponse.failure(e.getMessage());
        }
    }
}
