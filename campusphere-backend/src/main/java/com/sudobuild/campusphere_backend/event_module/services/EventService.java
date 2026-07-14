package com.sudobuild.campusphere_backend.event_module.services;

import com.sudobuild.campusphere_backend.event_module.models.Event;
import com.sudobuild.campusphere_backend.event_module.models.EventRegistration;
import com.sudobuild.campusphere_backend.student_module.enums.Department;
import org.springframework.data.domain.Slice;

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
     * @param eventId the id of event to delete
     * @return if the event is deleted successfully
     */
    boolean deleteEvent(String eventId);

    /**
     * Retrieves an event by its unique ID.
     *
     * @param id the unique identifier of the event
     * @return the event if found
     */
    Event getEventById(String id);

    /**
     * Retrieves a paginated list of all upcoming events.
     *
     * @param pageNumber the page number to retrieve (0-indexed)
     * @param pageSize   the number of events per page
     * @return a {@link Slice} of upcoming events
     */
    Slice<Event> getAllUpcomingEvents(int pageNumber, int pageSize);

    /**
     * Retrieves a paginated list of all events associated with a specific department.
     *
     * @param departmentId the unique identifier of the department
     * @param pageNumber   the page number to retrieve (0-indexed)
     * @param pageSize     the number of events per page
     * @return a {@link Slice} of events for the specified department
     */
    Slice<Event> getAllEventsOfDepartment(Department department, int pageNumber, int pageSize);

    /**
     * Retrieves a paginated list of all events associated with a specific club.
     *
     * @param clubId     the unique identifier of the club
     * @param pageNumber the page number to retrieve (0-indexed)
     * @param pageSize   the number of events per page
     * @return a {@link Slice} of events for the specified club
     */
    Slice<Event> getAllClubEvents(String clubId, int pageNumber, int pageSize);

    /**
     * Registers a student for a specific event.
     *
     * @param eventId   the unique identifier of the event
     * @param studentId the unique identifier of the student
     * @return the resulting event registration
     */
    EventRegistration registerForEvent(String eventId, String studentId);

    /**
     * Cancels an existing event registration.
     *
     * @param eventRegistrationId the unique identifier of the event registration to
     *                            cancel
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
     * Retrieves a paginated list of event registrations (attendance list) for a specific event.
     *
     * @param eventId    the unique identifier of the event
     * @param pageNumber the page number to retrieve (0-indexed)
     * @param pageSize   the number of registrations per page
     * @return a {@link Slice} of {@link EventRegistration} objects representing the attendance list
     */
    Slice<EventRegistration> getEventAttendanceList(String eventId, int pageNumber, int pageSize);
}
