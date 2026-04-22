package com.sudobuild.campusphere_backend.authentication_module.models;

import com.sudobuild.campusphere_backend.authentication_module.enums.UserRole;

import jakarta.persistence.*;

import lombok.Getter;
import lombok.Setter;

/**
 * Represents an authenticated user in the CampuSphere system.
 * <p>
 * This entity stores core authentication and identification details
 * for all user types (students, admins, faculty, alumni).
 * </p>
 */
@Getter
@Setter
public class User {

    /** Unique identifier, auto-generated as a UUID. */
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private String id;

    /** User's email address, used as the login credential. Must be unique and non-null. */
    @Column(unique = true, nullable = false)
    private String email;

    /** Hashed password for authentication. */
    private String password;

    /** The role assigned to this user, stored as a string in the database. */
    @Enumerated(EnumType.STRING)
    private UserRole role;

    /** Firebase Cloud Messaging token for sending push notifications to the user's mobile device. */
    private String mobileDeviceToken;
}
