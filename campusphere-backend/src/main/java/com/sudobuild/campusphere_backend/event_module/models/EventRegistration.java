package com.sudobuild.campusphere_backend.event_module.models;

import java.time.Instant;

import org.springframework.data.annotation.Id;

import com.sudobuild.campusphere_backend.event_module.enums.EventRegistrationStatus;
import com.sudobuild.campusphere_backend.student_module.models.Student;

import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.Setter;


@Getter
@Setter
@Entity
@Table(name="event_registrations")

/**
 * Represents a student's registration for a specific event.
 */
public class EventRegistration {
    
    /**
     * Unique identifier for the event registration.
     */
    @Id
    @GeneratedValue(strategy=GenerationType.UUID)
    private String id;

    /**
     * The event that the student is registered for.
     */
    @ManyToOne
    @JoinColumn(name="event_id")
    private Event event;

    /**
     * The student who has registered for the event.
     */
    @ManyToOne
    @JoinColumn(name="student_id")
    private Student student;

    /**
     * The date and time when the registration was made.
     */
    private Instant registrationTime;
    
    /**
     * The current status of this registration.
     */
    @Enumerated(EnumType.STRING)
    private EventRegistrationStatus status;

}
