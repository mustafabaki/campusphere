package com.sudobuild.campusphere_backend.student_module.repositories;

import org.springframework.data.jpa.repository.JpaRepository;

import com.sudobuild.campusphere_backend.student_module.models.SocialLink;

public interface SocialLinkRepository extends JpaRepository<SocialLink, String> {
}