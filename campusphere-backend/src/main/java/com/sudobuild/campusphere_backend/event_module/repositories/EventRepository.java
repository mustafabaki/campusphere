package com.sudobuild.campusphere_backend.event_module.repositories;

import org.springframework.data.jpa.repository.JpaRepository;

import com.sudobuild.campusphere_backend.event_module.models.Event;

public interface EventRepository extends JpaRepository<Event, String> {
    
}
