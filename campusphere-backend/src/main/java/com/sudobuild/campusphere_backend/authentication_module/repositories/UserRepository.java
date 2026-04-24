package com.sudobuild.campusphere_backend.authentication_module.repositories;

import org.springframework.data.jpa.repository.JpaRepository;

import com.sudobuild.campusphere_backend.authentication_module.models.CampusphereUser;

public interface UserRepository extends JpaRepository<CampusphereUser, String> {

    CampusphereUser findByEmail(String email);

}
