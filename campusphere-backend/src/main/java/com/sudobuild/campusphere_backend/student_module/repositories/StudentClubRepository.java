package com.sudobuild.campusphere_backend.student_module.repositories;

import com.sudobuild.campusphere_backend.student_module.models.StudentClub;
import org.springframework.data.jpa.repository.JpaRepository;

public interface StudentClubRepository extends JpaRepository<StudentClub, String> {
}