package com.sudobuild.campusphere_backend.event_module.repositories;

import com.sudobuild.campusphere_backend.event_module.enums.EventRegistrationStatus;
import com.sudobuild.campusphere_backend.event_module.models.EventRegistration;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Slice;
import org.springframework.data.jpa.repository.JpaRepository;

public interface EventRegistrationRepository extends JpaRepository<EventRegistration, String> {
    Slice<EventRegistration> findByStatus(EventRegistrationStatus status, Pageable pageable);
}
