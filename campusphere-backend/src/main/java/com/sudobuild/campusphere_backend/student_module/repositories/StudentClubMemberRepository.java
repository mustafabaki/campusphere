package com.sudobuild.campusphere_backend.student_module.repositories;

import org.springframework.data.jpa.repository.JpaRepository;

import com.sudobuild.campusphere_backend.student_module.models.StudentClubMember;

import java.util.List;
import java.util.Optional;

public interface StudentClubMemberRepository extends JpaRepository<StudentClubMember, String> {
    Optional<StudentClubMember> findByClubIdAndStudentId(String clubId, String studentId);
    List<StudentClubMember> findAllByClubId(String clubId);
    List<StudentClubMember> findAllByStudentId(String studentId);
}
