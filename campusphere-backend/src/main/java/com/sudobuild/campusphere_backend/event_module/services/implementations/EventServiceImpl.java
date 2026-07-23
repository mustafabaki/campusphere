package com.sudobuild.campusphere_backend.event_module.services.implementations;

import com.sudobuild.campusphere_backend.event_module.enums.EventRegistrationStatus;
import com.sudobuild.campusphere_backend.event_module.enums.EventStatus;
import com.sudobuild.campusphere_backend.event_module.models.Event;
import com.sudobuild.campusphere_backend.event_module.models.EventRegistration;
import com.sudobuild.campusphere_backend.event_module.repositories.EventRegistrationRepository;
import com.sudobuild.campusphere_backend.event_module.repositories.EventRepository;
import com.sudobuild.campusphere_backend.event_module.services.EventService;
import com.sudobuild.campusphere_backend.student_module.enums.Department;
import com.sudobuild.campusphere_backend.student_module.repositories.StudentClubRepository;
import com.sudobuild.campusphere_backend.student_module.repositories.StudentRepository;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Slice;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Instant;
import java.util.List;
import java.util.Random;

/**
 * Implementation of the {@link EventService} interface.
 * Provides business logic for managing events and event registrations.
 */
@Service
public class EventServiceImpl implements EventService {
    private final EventRepository eventRepository;
    private final StudentClubRepository studentClubRepository;
    private final StudentRepository studentRepository;
    private final EventRegistrationRepository eventRegistrationRepository;


    /**
     * Constructs an instance of {@code EventServiceImpl}.
     *
     * @param eventRepository the repository for event operations
     * @param studentClubRepository the repository for student club operations
     * @param studentRepository the repository for student operations
     * @param eventRegistrationRepository the repository for event registration operations
     */
    public EventServiceImpl(EventRepository eventRepository, StudentClubRepository studentClubRepository, StudentRepository studentRepository, EventRegistrationRepository eventRegistrationRepository) {
        this.eventRepository = eventRepository;
        this.studentClubRepository = studentClubRepository;
        this.studentRepository = studentRepository;
        this.eventRegistrationRepository = eventRegistrationRepository;
    }

    /**
     * Creates a new event.
     *
     * @param event the event to create
     * @return the created event
     * @throws RuntimeException if the event end time is not after the start time
     */
    @Override
    public Event createEvent(Event event) {
        try {
            if (event.getStartTime().isBefore(event.getEndTime())) {
                return this.eventRepository.save(event);
            } else {
                throw new RuntimeException("event end time must be later than start time.");
            }
        } catch (Exception e) {
            throw e;
        }
    }

    /**
     * Updates an existing event. Only non-null fields in the provided event object will be updated.
     *
     * @param event the event containing the updated details
     * @return the updated event
     * @throws RuntimeException if the event is not found, or if the new capacity is less than the current number of attendees
     */
    @Override
    public Event updateEvent(Event event) {
       try {
            // fetch the event fro database
            var savedEvent = eventRepository.findById(event.getId()).orElseThrow(() -> new RuntimeException("Event not found with id: " + event.getId()));

            // only update the non null attributes
            if(event.getCapacity() > 0) {
                event.setCapacity(event.getCapacity());
                if(savedEvent.getCurrentAttendees() > event.getCapacity()) {
                    throw new RuntimeException("The new event capacity " + event.getCapacity() + " is less than the current number of attendees " + savedEvent.getCurrentAttendees() + ".");
                }
            }

            if(event.getEndTime() != null) {
                event.setEndTime(event.getEndTime());
            }

            if(event.getStartTime() != null) {
                event.setStartTime(event.getStartTime());
            }

            if(event.getTitle() != null) {
                event.setTitle(event.getTitle());
            }

            if(event.getDescription() != null) {
                event.setDescription(event.getDescription());
            }

            if(event.getLocation() != null) {
                event.setLocation(event.getLocation());
            }

            if(event.getStatus() != null) {
                event.setStatus(event.getStatus());
            }

            if(event.getDepartmentOrganizer() != null) {
                event.setDepartmentOrganizer(event.getDepartmentOrganizer());
            }

            if(event.getStudentClubOrganizer() != null) {
                event.setStudentClubOrganizer(event.getStudentClubOrganizer());
            }

            if(event.getCoverImageUrl() != null) {
                event.setCoverImageUrl(event.getCoverImageUrl());
            }

            return eventRepository.save(event);
       } catch (Exception e) {
        throw e;
       }
    }

    /**
     * Deletes an event by its ID.
     *
     * @param eventId the ID of the event to delete
     * @return {@code true} if the event was successfully deleted, {@code false} if the event was not found
     */
    @Override
    @Transactional
    public boolean deleteEvent(String eventId) {
        // check if the event is null.
        try {
            Event event = eventRepository.findById(eventId).orElseGet(null);

            if (event != null) {
                this.eventRegistrationRepository.deleteByEvent(event);
                this.eventRepository.delete(event);
                return true;
            }

            return false;
        } catch (Exception e) {
            throw e;
        }
    }

    /**
     * Retrieves an event by its ID.
     *
     * @param id the ID of the event
     * @return the event if found, or {@code null} if not found
     */
    @Override
    public Event getEventById(String id) {
        try {
            Event event = eventRepository.findById(id).orElseGet(null);
            if (event != null) {
                return event;
            }

            return null;
        } catch (Exception e) {
            throw e;
        }
    }

    /**
     * Retrieves a paginated list of all upcoming events.
     *
     * @param pageNumber the page number to retrieve
     * @param pageSize the number of items per page
     * @return a slice of upcoming events
     */
    @Override
    public Slice<Event> getAllUpcomingEvents(int pageNumber, int pageSize) {
        try {
            Pageable pageable = PageRequest.of(pageNumber, pageSize);
            return eventRepository.findByStatus(EventStatus.UPCOMING, pageable);
        } catch (Exception e) {
            throw e;
        }
    }

    /**
     * Retrieves a paginated list of all events organized by a specific department.
     *
     * @param department the department
     * @param pageNumber the page number to retrieve
     * @param pageSize the number of items per page
     * @return a slice of events for the specified department
     */
    @Override
    public Slice<Event> getAllEventsOfDepartment(Department department, int pageNumber, int pageSize) {
        try {
            Pageable pageable = PageRequest.of(pageNumber, pageSize);
            return eventRepository.findByDepartmentOrganizer(department, pageable);
        } catch (Exception e) {
            throw e;
        }
    }

    /**
     * Retrieves a paginated list of all events organized by a specific student club.
     *
     * @param clubId the ID of the student club
     * @param pageNumber the page number to retrieve
     * @param pageSize the number of items per page
     * @return a slice of events for the specified club
     * @throws RuntimeException if the club is not found
     */
    @Override
    public Slice<Event> getAllClubEvents(String clubId, int pageNumber, int pageSize) {
        try {
            Pageable pageable = PageRequest.of(pageNumber, pageSize);
            // find the club
            var club = studentClubRepository.findById(clubId).orElseThrow(() -> new RuntimeException("Club not found with id: " + clubId));
            return eventRepository.findByStudentClubOrganizer(club, pageable);
        } catch (Exception e) {
            throw e;
        }
    }

    /**
     * Registers a student for an event.
     *
     * @param eventId the ID of the event
     * @param studentId the ID of the student
     * @return the created event registration
     * @throws RuntimeException if the event is not found, the event is full, or the student is not found
     */
    @Override
    public EventRegistration registerForEvent(String eventId, String studentId) {
        // find the event
        var event = eventRepository.findById(eventId).orElseThrow(() -> new RuntimeException("Event not found with id: " + eventId));

        // check if the event is full
        if (event.getCapacity() == event.getCurrentAttendees()) {
            throw new RuntimeException("Event is full");

        } else {
            // find the student
            var student = studentRepository.findById(studentId).orElseThrow(() -> new RuntimeException("Student not found with id: " + studentId));
            // create the registration
            var registration = new EventRegistration();

            registration.setEvent(event);
            registration.setStudent(student);
            registration.setRegistrationTime(Instant.now());
            registration.setStatus(EventRegistrationStatus.REGISTERED);

            // save the registration on the database
            var savedRegistration = eventRegistrationRepository.save(registration);

            // increment attendee number by one
            event.setCurrentAttendees(event.getCurrentAttendees() + 1);
            eventRepository.save(event);

            return savedRegistration;
        }

    }

    /**
     * Cancels an existing event registration.
     *
     * @param eventRegistrationId the ID of the event registration to cancel
     * @return the updated event registration with a cancelled status
     * @throws RuntimeException if the event registration is not found
     */
    @Override
    public EventRegistration cancelEventRegistration(String eventRegistrationId) {
        // find the event registration
        var eventRegistration = eventRegistrationRepository.findById(eventRegistrationId).orElseThrow(() -> new RuntimeException("Event registration not found"));

        // update the event registration status to cancelled
        eventRegistration.setStatus(EventRegistrationStatus.CANCELLED);
        return eventRegistrationRepository.save(eventRegistration);
    }

    /**
     * Marks attendance for an event registration.
     *
     * @param eventRegistrationId the ID of the event registration
     * @return the updated event registration with an attended status
     * @throws RuntimeException if the event registration is not found
     */
    @Override
    public EventRegistration markAttendance(String eventRegistrationId) {
       // find the event registration
        var eventRegistration = eventRegistrationRepository.findById(eventRegistrationId).orElseThrow(() -> new RuntimeException("Event registration not found"));

        // update the event registration status to attended
        eventRegistration.setStatus(EventRegistrationStatus.ATTENDED);
        return eventRegistrationRepository.save(eventRegistration);
    }

    /**
     * Retrieves a paginated list of event registrations marked as attended for a specific event.
     *
     * @param eventId the ID of the event
     * @param pageNumber the page number to retrieve
     * @param pageSize the number of items per page
     * @return a slice of attended event registrations
     * @throws RuntimeException if the event is not found
     */
    @Override
    public Slice<EventRegistration> getEventAttendanceList(String eventId, int pageNumber, int pageSize) {
       // set the pageable object
        Pageable pageable = PageRequest.of(pageNumber, pageSize);

        // get the rows where the event registration status is attended for the given event id
        return eventRegistrationRepository.findByStatusAndEvent(EventRegistrationStatus.ATTENDED, eventRepository.findById(eventId).orElseThrow(() -> new RuntimeException("Event not found with id: " + eventId)), pageable);

    }

    /**
     * Retrieves a random upcoming event.
     *
     * @return a random upcoming event, or {@code null} if no upcoming events are found
     */
    @Override
    public Event getRandomUpcomingEvent() {
       // create a list of all upcoming events
        List<Event> upcomingEvents = eventRepository.findByStatus(EventStatus.UPCOMING);

        if (upcomingEvents.isEmpty()) {
            return null;
        }

        // pick a random event from the list
        Random random = new Random();
        return upcomingEvents.get(random.nextInt(upcomingEvents.size()));
    }

    
}
