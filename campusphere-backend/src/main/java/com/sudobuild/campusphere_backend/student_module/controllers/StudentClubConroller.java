package com.sudobuild.campusphere_backend.student_module.controllers;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.sudobuild.campusphere_backend.auxiliary.ApiResponse;
import com.sudobuild.campusphere_backend.student_module.enums.ClubRole;
import com.sudobuild.campusphere_backend.student_module.models.StudentClub;
import com.sudobuild.campusphere_backend.student_module.models.StudentClubMember;
import com.sudobuild.campusphere_backend.student_module.services.StudentClubService;

@RestController
@RequestMapping("api/clubs")
public class StudentClubConroller {

    private final StudentClubService studentClubService;

    public StudentClubConroller(StudentClubService studentClubService) {
        this.studentClubService = studentClubService;
    }

    // -------- Club Management Endpoints ---------

    @PostMapping()
    public ResponseEntity<?> createClub(@RequestBody StudentClub studentClub) {

        try {
            var createdClub = studentClubService.createClub(studentClub);
            return ResponseEntity.ok(ApiResponse.success(createdClub));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.failure(e.getMessage()));
        }
    }

    @GetMapping()
    public ResponseEntity<?> getAllClubs() {
        try {
            var clubs = studentClubService.getAllClubs();
            return ResponseEntity.ok(ApiResponse.success(clubs));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.failure(e.getMessage()));
        }
    }

    @GetMapping("/{id}")
    public ResponseEntity<?> getClubById(@PathVariable String id) {
        try {
            var club = studentClubService.getClubById(id);
            return ResponseEntity.ok(ApiResponse.success(club));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.failure(e.getMessage()));
        }
    }

    @PutMapping("/{id}")
    public ResponseEntity<?> updateClub(@PathVariable String id, @RequestBody StudentClub studentClub) {
        try {
            var updatedClub = studentClubService.updateClub(id, studentClub);
            return ResponseEntity.ok(ApiResponse.success(updatedClub));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.failure(e.getMessage()));
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<?> deleteClub(@PathVariable String id) {
        try {
            studentClubService.deleteClub(id);
            return ResponseEntity.ok(ApiResponse.success(null));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.failure(e.getMessage()));
        }
    }

    // -------- Membership Management Endpoints ---------

    @PostMapping("/{id}/members/{studentId}")
    public ResponseEntity<?> addMember(@PathVariable String id, @PathVariable String studentId,
            @RequestBody ClubRole clubRole) {
        try {
            StudentClubMember member = studentClubService.addMember(id, studentId, clubRole);
            return ResponseEntity.ok(ApiResponse.success(member));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.failure(e.getMessage()));
        }
    }

    @DeleteMapping("/{id}/members/{studentId}")
    public ResponseEntity<?> removeMember(@PathVariable String id, @PathVariable String studentId) {
        try {
            studentClubService.removeMember(id, studentId);
            return ResponseEntity.ok(ApiResponse.success(null));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.failure(e.getMessage()));
        }
    }

    @GetMapping("/{id}/members")
    public ResponseEntity<?> getMembersByClubId(@PathVariable String id){
        
        try {
            var members = studentClubService.getMembersByClubId(id);
            return ResponseEntity.ok(ApiResponse.success(members));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.failure(e.getMessage()));
        }
    }

}
