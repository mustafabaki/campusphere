package com.sudobuild.campusphere_backend.event_module.repositories;

import com.sudobuild.campusphere_backend.event_module.enums.EventStatus;
import com.sudobuild.campusphere_backend.student_module.enums.Department;
import com.sudobuild.campusphere_backend.student_module.models.StudentClub;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Slice;
import org.springframework.data.jpa.repository.JpaRepository;

import com.sudobuild.campusphere_backend.event_module.models.Event;

import java.util.List;

public interface EventRepository extends JpaRepository<Event, String> {
    Slice<Event> findByDepartmentOrganizer(Department departmentOrganizer, Pageable pageable);
    Slice<Event> findByStatus(EventStatus status, Pageable pageable);

    Slice<Event> findByStudentClubOrganizer(StudentClub studentClubOrganizer, Pageable pageable);

    Event findTopByDepartmentOrganizerOrderByStartTimeDesc(Department departmentOrganizer);

    List<Event> findByStatus(EventStatus status);
}
