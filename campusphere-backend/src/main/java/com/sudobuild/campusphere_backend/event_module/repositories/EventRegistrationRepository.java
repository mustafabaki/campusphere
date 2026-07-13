package com.sudobuild.campusphere_backend.event_module.repositories;

import com.sudobuild.campusphere_backend.event_module.models.EventRegistration;
import org.springframework.data.jpa.repository.JpaRepository;

public interface EventRegistrationRepository extends JpaRepository<EventRegistration, String> {
}
