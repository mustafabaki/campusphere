package com.sudobuild.campusphere_backend.event_module.services;

import java.util.List;

import com.sudobuild.campusphere_backend.event_module.models.Event;
import com.sudobuild.campusphere_backend.event_module.models.EventRegistration;

/**
 * Service interface for managing events and event registrations.
 */
public interface EventService {
    
    /**
     * Creates a new event.
     *
     * @param event the event to create
     * @return the created event
     */
    Event createEvent(Event event);

    /**
     * Updates an existing event.
     *
     * @param event the event with updated details
     * @return the updated event
     */
    Event updateEvent(Event event);

    /**
     * Deletes an event.
     *
     * @param event the event to delete
     * @return the deleted event
     */
    Event deleteEvent(Event event);

    /**
     * Retrieves an event by its unique ID.
     *
     * @param id the unique identifier of the event
     * @return the event if found
     */
    Event getEventById(String id);

    /**
     * Retrieves a list of all upcoming events.
     *
     * @return a list of upcoming events
     */
    List<Event> getAllUpcomingEvents();

    /**
     * Retrieves a list of all events associated with a specific department.
     *
     * @param departmentId the unique identifier of the department
     * @return a list of events for the specified department
     */
    List<Event> getAllEventsOfDepartment(String departmentId);

    /**
     * Retrieves a list of all events associated with a specific club.
     *
     * @param clubId the unique identifier of the club
     * @return a list of events for the specified club
     */
    List<Event> getAllClubEvents(String clubId);

    /**
     * Registers a student for a specific event.
     *
     * @param eventId the unique identifier of the event
     * @param studentId the unique identifier of the student
     * @return the resulting event registration
     */
    EventRegistration registerForEvent(String eventId, String studentId);

    /**
     * Cancels an existing event registration.
     *
     * @param eventRegistrationId the unique identifier of the event registration to cancel
     * @return the cancelled event registration
     */
    EventRegistration cancelEventRegistration(String eventRegistrationId);

    /**
     * Marks a student as attended for a specific event registration.
     *
     * @param eventRegistrationId the unique identifier of the event registration
     * @return the updated event registration with attendance marked
     */
    EventRegistration markAttendance(String eventRegistrationId);

    /**
     * Retrieves the list of event registrations (attendance list) for a specific event.
     *
     * @param eventId the unique identifier of the event
     * @return a list of event registrations for the specified event
     */
    List<EventRegistration> getEventAttendanceList(String eventId);
}
