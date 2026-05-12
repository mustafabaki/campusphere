package com.sudobuild.campusphere_backend.student_module.controllers;

import com.sudobuild.campusphere_backend.auxiliary.ApiResponse;
import com.sudobuild.campusphere_backend.student_module.DTOs.StudentCreateDTO;
import com.sudobuild.campusphere_backend.student_module.DTOs.StudentResponseDTO;
import com.sudobuild.campusphere_backend.student_module.enums.SocialMediaPlatform;
import com.sudobuild.campusphere_backend.student_module.services.StudentClubService;
import com.sudobuild.campusphere_backend.student_module.services.StudentService;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("api/student")
public class StudentController {
    private final StudentService studentService;
    private final StudentClubService studentClubService;

    public StudentController(StudentService studentService, StudentClubService studentClubService) {
        this.studentService = studentService;
        this.studentClubService = studentClubService;
    }

    @PostMapping("/create")
    @PreAuthorize("hasRole('ADMIN')")
    public ApiResponse<?> createStudent(@RequestBody StudentCreateDTO student) {
        try {
            var savedStudent = studentService.create(student);
            return ApiResponse.success(savedStudent);
        } catch (Exception e) {
            return ApiResponse.failure(e.getMessage());
        }
    }

    @GetMapping("/getStudentByEmail")
    @PreAuthorize("hasRole('STUDENT') or hasRole('ADMIN')")
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
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<?> deleteStudentById(@RequestParam("id") String id) {
        try {
            studentService.deleteStudent(id);
            return ResponseEntity.ok(ApiResponse.success(null));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.failure(e.getMessage()));
        }
    }

    @PutMapping("updateStudentById")
    @PreAuthorize("hasRole('STUDENT') or hasRole('ADMIN')")
    public ResponseEntity<ApiResponse> updateStudentById(@RequestParam("id") String id,
            @RequestBody StudentCreateDTO student) {
        try {
            var updatedStudent = studentService.updateStudent(id, student);
            return ResponseEntity.ok(ApiResponse.success(updatedStudent));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.failure(e.getMessage()));
        }
    }

    @PostMapping("addSocialLinkToStudent")
    @PreAuthorize("hasRole('STUDENT') or hasRole('ADMIN')")
    public ResponseEntity<?> addSocialLinkToStudent(@RequestParam String studentId, @RequestParam String url,
            @RequestParam SocialMediaPlatform platform) {
        try {
            var updatedStudent = studentService.addSocialLinkToStudent(studentId, url, platform);
            return ResponseEntity.ok(ApiResponse.success(updatedStudent));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.failure(e.getMessage()));
        }
    }

    @GetMapping("/{studentId}/clubs")
    @PreAuthorize("hasRole('STUDENT') or hasRole('ADMIN')")
    public ResponseEntity<?> getClubsByStudentId(@PathVariable String studentId) {
        try {
            var clubs = studentClubService.getClubMembershipsByStudentId(studentId);
            return ResponseEntity.ok(ApiResponse.success(clubs));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.failure(e.getMessage()));
        }
    }
}
