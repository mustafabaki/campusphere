package com.sudobuild.campusphere_backend.student_module.services;

import com.sudobuild.campusphere_backend.student_module.models.StudentClub;
import java.util.List;

public interface StudentClubService {
    StudentClub create(StudentClub studentClub);
    StudentClub update(String id, StudentClub studentClub);
    void delete(String id);
    StudentClub getById(String id);
    List<StudentClub> getAll();
}
