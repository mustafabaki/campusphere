package com.sudobuild.campusphere_backend.authentication_module.models;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

import com.sudobuild.campusphere_backend.authentication_module.enums.UserRole;

import jakarta.persistence.*;


/**
 * Represents an authenticated user in the CampuSphere system.
 * <p>
 * This entity stores core authentication and identification details
 * for all user types (students, admins, faculty, alumni).
 * </p>
 */
@Entity
@Table(name = "users")
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



    /** @return the unique UUID identifier of this user. */
    public String getId() {
        return id;
    }

    /** @param id the unique UUID identifier to assign to this user. */
    public void setId(String id) {
        this.id = id;
    }

    /** @return the user's email address. */
    public String getEmail() {
        return email;
    }

    /** @param email the email address to assign to this user. */
    public void setEmail(String email) {
        this.email = email;
    }

    /** @return the BCrypt-hashed password. */
    public String getPassword() {
        return password;
    }

    /**
     * Hashes the provided plain-text password using BCrypt and stores the result.
     * <p><strong>Note:</strong> A new {@link BCryptPasswordEncoder} instance is created
     * on every invocation. Consider injecting a shared encoder for better performance.</p>
     *
     * @param password the plain-text password to hash and store.
     */
    public void setPassword(String password) {
        BCryptPasswordEncoder bCryptPasswordEncoder = new BCryptPasswordEncoder();
        this.password = bCryptPasswordEncoder.encode(password);
    }

    /** @return the role assigned to this user. */
    public UserRole getRole() {
        return role;
    }

    /** @param role the {@link UserRole} to assign to this user. */
    public void setRole(UserRole role) {
        this.role = role;
    }

    /** @return the mobile device token used for push notifications. */
    public String getMobileDeviceToken() {
        return mobileDeviceToken;
    }

    /** @param mobileDeviceToken the device token to associate with this user. */
    public void setMobileDeviceToken(String mobileDeviceToken) {
        this.mobileDeviceToken = mobileDeviceToken;
    }
}
