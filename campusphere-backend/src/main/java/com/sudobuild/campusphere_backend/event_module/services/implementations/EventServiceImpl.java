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

import java.time.Instant;

@Service
public class EventServiceImpl implements EventService {
    private final EventRepository eventRepository;
    private final StudentClubRepository studentClubRepository;
    private final StudentRepository studentRepository;
    private final EventRegistrationRepository eventRegistrationRepository;


    public EventServiceImpl(EventRepository eventRepository, StudentClubRepository studentClubRepository, StudentRepository studentRepository, EventRegistrationRepository eventRegistrationRepository) {
        this.eventRepository = eventRepository;
        this.studentClubRepository = studentClubRepository;
        this.studentRepository = studentRepository;
        this.eventRegistrationRepository = eventRegistrationRepository;
    }

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

    @Override
    public Event updateEvent(Event event) {
        // TODO Auto-generated method stub
        throw new UnsupportedOperationException("Unimplemented method 'updateEvent'");
    }

    @Override
    public boolean deleteEvent(String eventId) {
        // check if the event is null.
        try {
            Event event = eventRepository.findById(eventId).orElseGet(null);

            if (event != null) {
                this.eventRepository.delete(event);
                return true;
            }

            return false;
        } catch (Exception e) {
            throw e;
        }
    }

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

    @Override
    public Slice<Event> getAllUpcomingEvents(int pageNumber, int pageSize) {
        try {
            Pageable pageable = PageRequest.of(pageNumber, pageSize);
            return eventRepository.findByStatus(EventStatus.UPCOMING, pageable);
        } catch (Exception e) {
            throw e;
        }
    }

    @Override
    public Slice<Event> getAllEventsOfDepartment(Department department, int pageNumber, int pageSize) {
        try {
            Pageable pageable = PageRequest.of(pageNumber, pageSize);
            return eventRepository.findByDepartmentOrganizer(department, pageable);
        } catch (Exception e) {
            throw e;
        }
    }

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

    @Override
    public EventRegistration cancelEventRegistration(String eventRegistrationId) {
        // find the event registration
        var eventRegistration = eventRegistrationRepository.findById(eventRegistrationId).orElseThrow(() -> new RuntimeException("Event registration not found"));

        // update the event registration status to cancelled
        eventRegistration.setStatus(EventRegistrationStatus.CANCELLED);
        return eventRegistrationRepository.save(eventRegistration);
    }

    @Override
    public EventRegistration markAttendance(String eventRegistrationId) {
       // find the event registration
        var eventRegistration = eventRegistrationRepository.findById(eventRegistrationId).orElseThrow(() -> new RuntimeException("Event registration not found"));

        // update the event registration status to attended
        eventRegistration.setStatus(EventRegistrationStatus.ATTENDED);
        return eventRegistrationRepository.save(eventRegistration);
    }

    @Override
    public Slice<EventRegistration> getEventAttendanceList(String eventId, int pageNumber, int pageSize) {
       // set the pageable object
        Pageable pageable = PageRequest.of(pageNumber, pageSize);

        // find the event
        var event = eventRepository.findById(eventId).orElseThrow(() -> new RuntimeException("Event not found with id: " + eventId));

        // get the rows where the event registration status is attended
        return eventRegistrationRepository.findByStatus(EventRegistrationStatus.ATTENDED, pageable);

    }

}
