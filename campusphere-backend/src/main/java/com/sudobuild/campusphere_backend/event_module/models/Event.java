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
/**
 * Represents an event within the CampuSphere platform.
 * An event can be organized by either a Student Club or a Department.
 */
public class Event {

    /**
     * Unique identifier for the event.
     */
    @Id
    @GeneratedValue(strategy=GenerationType.UUID)
    private String id;

    /**
     * The title or name of the event.
     */
    private String title;

    /**
     * A detailed description of the event.
     */
    private String description;

    /**
     * The physical or virtual location where the event takes place.
     */
    private String location;

    /**
     * The starting date and time of the event.
     */
    private Instant startTime;

    /**
     * The ending date and time of the event.
     */
    private Instant endTime;
    
    /**
     * The student club organizing the event, if applicable.
     * Mutually exclusive with departmentOrganizer.
     */
    @ManyToOne
    @JoinColumn(name = "student_club_id")
    private StudentClub studentClubOrganizer;

    /**
     * The department organizing the event, if applicable.
     * Mutually exclusive with studentClubOrganizer.
     */
    @Enumerated(EnumType.STRING)
    private Department departmentOrganizer;

    /**
     * The category or type of the event.
     */
    @Enumerated(EnumType.STRING)
    private EventCategory category;

    /**
     * The maximum number of attendees allowed for the event.
     */
    private int capacity;

    /**
     * The current lifecycle status of the event.
     */
    @Enumerated(EnumType.STRING)
    private EventStatus status;
    
}
