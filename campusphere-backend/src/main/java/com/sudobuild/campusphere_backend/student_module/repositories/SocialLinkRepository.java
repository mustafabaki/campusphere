package com.sudobuild.campusphere_backend.student_module.repositories;

import com.sudobuild.campusphere_backend.student_module.models.SocialLink;
import org.springframework.data.jpa.repository.JpaRepository;

public interface SocialLinkRepository extends JpaRepository<SocialLink, String> {
}