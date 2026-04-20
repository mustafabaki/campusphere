package com.sudobuild.campusphere_backend.student_module.controllers;

import com.sudobuild.campusphere_backend.auxiliary.ApiResponse;
import com.sudobuild.campusphere_backend.student_module.DTOs.StudentCreateDTO;
import com.sudobuild.campusphere_backend.student_module.DTOs.StudentResponseDTO;
import com.sudobuild.campusphere_backend.student_module.services.StudentService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

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

    @GetMapping("/getStudentByEmail")
    public ResponseEntity<ApiResponse> getStudentByEmail(@RequestParam("email") String email) {
        try {
            var savedStudent = studentService.getStudentByEmail(email);
            ApiResponse<StudentResponseDTO> response = ApiResponse.success(savedStudent);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            var response = ApiResponse.failure(e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }

    @DeleteMapping("deleteStudentById")
    public ApiResponse<?> deleteStudentById(@RequestParam("id") String id) {
        try {
            studentService.deleteStudent(id);
            return ApiResponse.success(null);
        } catch (Exception e) {
            return ApiResponse.failure(e.getMessage());
        }
    }

    @PutMapping("updateStudentById")
    public ResponseEntity<ApiResponse> updateStudentById(@RequestParam("id") String id, @RequestBody StudentCreateDTO student) {
        try {
            var updatedStudent = studentService.updateStudent(id, student);
            return ResponseEntity.ok(ApiResponse.success(updatedStudent));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.failure(e.getMessage()));
        }
    }
}
