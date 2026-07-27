package com.sudobuild.campusphere_backend.event_module.enums;

/**
 * Represents the status of a user's registration for an event.
 */
public enum EventRegistrationStatus {
    /**
     * The user has successfully registered for the event but has not yet attended.
     */
    REGISTERED,

    /**
     * The user has attended the event they registered for.
     */
    ATTENDED,

    /**
     * The user or an administrator has cancelled the registration.
     */
    CANCELLED

}
