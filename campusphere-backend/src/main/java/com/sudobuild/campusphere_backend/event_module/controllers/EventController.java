package com.sudobuild.campusphere_backend.event_module.controllers;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.sudobuild.campusphere_backend.auxiliary.ApiResponse;
import com.sudobuild.campusphere_backend.event_module.models.Event;
import com.sudobuild.campusphere_backend.event_module.services.EventService;
import com.sudobuild.campusphere_backend.student_module.enums.Department;

/**
 * REST controller for managing events within the CampuSphere application.
 * Provides endpoints for creating, retrieving, updating, deleting events,
 * as well as managing event registrations and attendance.
 */
@RestController
@RequestMapping("/api/events")
public class EventController {

    private final EventService eventService;

    /**
     * Constructs a new EventController with the specified EventService.
     *
     * @param eventService the service used for event-related business logic
     */
    public EventController(EventService eventService) {
        this.eventService = eventService;
    }

    /**
     * Retrieves a paginated list of upcoming events.
     *
     * @param pageNumber the page number to retrieve (zero-based)
     * @param pageSize   the number of events per page
     * @return a ResponseEntity containing an ApiResponse with the upcoming events
     *         or an error message
     */
    @GetMapping("/getUpcomingEvents")
    public ResponseEntity<?> getUpcomingEvents(@RequestParam int pageNumber, @RequestParam int pageSize) {
        try {
            var data = eventService.getAllUpcomingEvents(pageNumber, pageSize);
            return ResponseEntity.ok(ApiResponse.success(data));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.failure(e.getMessage()));
        }
    }

    /**
     * Retrieves the details of a specific event by its ID.
     *
     * @param eventId the unique identifier of the event
     * @return a ResponseEntity containing an ApiResponse with the event details or
     *         an error message
     */
    @GetMapping("/getEvent")
    public ResponseEntity<?> getEvent(@RequestParam String eventId) {
        try {
            var data = eventService.getEventById(eventId);
            return ResponseEntity.ok(ApiResponse.success(data));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.failure(e.getMessage()));
        }
    }

    /**
     * Creates a new event.
     *
     * @param event the event details to be created
     * @return a ResponseEntity containing an ApiResponse with the created event or
     *         an error message
     */
    @PostMapping("/createEvent")
    public ResponseEntity<?> createEvent(@RequestBody Event event) {
        try {
            var data = eventService.createEvent(event);
            return ResponseEntity.ok(ApiResponse.success(data));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.failure(e.getMessage()));
        }
    }

    /**
     * Updates an existing event.
     *
     * @param event the event details to be updated
     * @return a ResponseEntity containing an ApiResponse with the updated event or
     *         an error message
     */
    @PutMapping("/updateEvent")
    public ResponseEntity<?> updateEvent(@RequestBody Event event) {
        try {
            var data = eventService.updateEvent(event);
            return ResponseEntity.ok(ApiResponse.success(data));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.failure(e.getMessage()));
        }
    }

    /**
     * Deletes a specific event by its ID.
     *
     * @param eventId the unique identifier of the event to be deleted
     * @return a ResponseEntity containing an ApiResponse with a success boolean or
     *         an error message
     */
    @DeleteMapping("/deleteEvent")
    public ResponseEntity<?> deleteEvent(@RequestParam String eventId) {
        try {
            boolean data = eventService.deleteEvent(eventId);
            return ResponseEntity.ok(ApiResponse.success(data));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.failure(e.getMessage()));
        }
    }

    /**
     * Retrieves a paginated list of events organized by a specific club.
     *
     * @param clubId     the unique identifier of the club
     * @param pageNumber the page number to retrieve (zero-based)
     * @param pageSize   the number of events per page
     * @return a ResponseEntity containing an ApiResponse with the club's events or
     *         an error message
     */
    @GetMapping("/getAllClubEvents")
    public ResponseEntity<?> getAllClubEvents(@RequestParam String clubId, @RequestParam int pageNumber,
            @RequestParam int pageSize) {
        try {
            var data = eventService.getAllClubEvents(clubId, pageNumber, pageSize);
            return ResponseEntity.ok(ApiResponse.success(data));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.failure(e.getMessage()));
        }
    }

    /**
     * Retrieves a paginated list of events organized by a specific department.
     *
     * @param department the department organizing the events
     * @param pageNumber the page number to retrieve (zero-based)
     * @param pageSize   the number of events per page
     * @return a ResponseEntity containing an ApiResponse with the department's
     *         events or an error message
     */
    @GetMapping("/getAllDepartmentEvents")
    public ResponseEntity<?> getAllDepartmentEvents(@RequestParam Department department, @RequestParam int pageNumber,
            @RequestParam int pageSize) {
        try {
            var data = eventService.getAllEventsOfDepartment(department, pageNumber, pageSize);
            return ResponseEntity.ok(ApiResponse.success(data));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.failure(e.getMessage()));
        }
    }

    /**
     * Registers a student for a specific event.
     *
     * @param eventId   the unique identifier of the event
     * @param studentId the unique identifier of the student
     * @return a ResponseEntity containing an ApiResponse with the event
     *         registration details or an error message
     */
    @PostMapping("/registerToEvent")
    public ResponseEntity<?> registerToEvent(@RequestParam String eventId, @RequestParam String studentId) {
        try {
            var data = eventService.registerForEvent(eventId, studentId);
            return ResponseEntity.ok(ApiResponse.success(data));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.failure(e.getMessage()));
        }
    }

    /**
     * Cancels an existing event registration.
     *
     * @param eventRegistrationId the unique identifier of the event registration to
     *                            be cancelled
     * @return a ResponseEntity containing an ApiResponse with the cancelled
     *         registration details or an error message
     */
    @PutMapping("/cancelRegistration")
    public ResponseEntity<?> cancelRegistration(@RequestParam String eventRegistrationId) {
        try {
            var data = eventService.cancelEventRegistration(eventRegistrationId);
            return ResponseEntity.ok(ApiResponse.success(data));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.failure(e.getMessage()));
        }
    }

    /**
     * Marks attendance for an event registration.
     *
     * @param eventRegistrationId the unique identifier of the event registration
     * @return a ResponseEntity containing an ApiResponse with the updated
     *         registration details or an error message
     */
    @PutMapping("/markAttendance")
    public ResponseEntity<?> markAttendance(@RequestParam String eventRegistrationId) {
        try {
            var data = eventService.markAttendance(eventRegistrationId);
            return ResponseEntity.ok(ApiResponse.success(data));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.failure(e.getMessage()));
        }
    }

    /**
     * Retrieves a paginated list of attendees for a specific event.
     *
     * @param eventId    the unique identifier of the event
     * @param pageNumber the page number to retrieve (zero-based)
     * @param pageSize   the number of attendees per page
     * @return a ResponseEntity containing an ApiResponse with the list of attendees
     *         or an error message
     */
    @GetMapping("/getEventAttendees")
    public ResponseEntity<?> getEventAttendees(@RequestParam String eventId, @RequestParam int pageNumber,
            @RequestParam int pageSize) {
        try {
            var data = eventService.getEventAttendanceList(eventId, pageNumber, pageSize);
            return ResponseEntity.ok(ApiResponse.success(data));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.failure(e.getMessage()));
        }
    }

    /**
     * Retrieves a random upcoming event.
     *
     * @return a ResponseEntity containing an ApiResponse with a random upcoming
     *         event or an error message
     */
    @GetMapping("/getRandomUpcomingEvent")
    public ResponseEntity<?> getRandomEvent() {
        try {
            var data = eventService.getRandomUpcomingEvent();
            return ResponseEntity.ok(ApiResponse.success(data));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.failure(e.getMessage()));
        }
    }

    /**
     * Retrieves a paginated list of all upcoming events.
     *
     * @param pageNumber the page number to retrieve (0-indexed)
     * @param pageSize   the number of events per page
     * @return a ResponseEntity containing an ApiResponse with a list of all
     *         upcoming events
     */
    @GetMapping("/getAllUpcomingEvents")
    public ResponseEntity<?> getAllUpcomingEvents(@RequestParam int pageNumber, @RequestParam int pageSize) {
        try {
            var data = eventService.getAllUpcomingEvents(pageNumber, pageSize);
            return ResponseEntity.ok(ApiResponse.success(data));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.failure(e.getMessage()));
        }
    }

    /**
     * Retrieves the first three event registrations for a specific event.
     * This is typically used to show a preview of attendees for the event.
     *
     * @param eventId the unique identifier of the event
     * @return a ResponseEntity containing an ApiResponse with the first three event
     *         registrations or an error message
     */
    @GetMapping("/getFirstThreeEventRegistrations")
    public ResponseEntity<?> getFirstThreeEventRegistrations(@RequestParam String eventId) {
        try {
            var data = eventService.getFirstThreeEventRegistrations(eventId);
            return ResponseEntity.ok(ApiResponse.success(data));

        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.failure(e.getMessage()));
        }
    }
}
