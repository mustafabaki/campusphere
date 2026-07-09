package com.sudobuild.campusphere_backend.event_module.models;

import java.time.Instant;

import com.sudobuild.campusphere_backend.event_module.enums.EventCategory;
import com.sudobuild.campusphere_backend.event_module.enums.EventStatus;

import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import jakarta.persistence.Entity;

import com.sudobuild.campusphere_backend.student_module.enums.Department;
import com.sudobuild.campusphere_backend.student_module.models.StudentClub;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Entity
@Table(name= "events")
public class Event {

    @Id
    @GeneratedValue(strategy=GenerationType.UUID)
    private String id;

    private String title;

    private String description;

    private String location;

    private Instant startTime;

    private Instant endTime;
    
    @ManyToOne
    @JoinColumn(name = "student_club_id")
    private StudentClub studentClubOrganizer;

    @Enumerated(EnumType.STRING)
    private Department departmentOrganizer;

    @Enumerated(EnumType.STRING)
    private EventCategory category;

    @Enumerated(EnumType.STRING)
    private EventStatus status;
    
}
