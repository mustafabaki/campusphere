package com.sudobuild.campusphere_backend.event_module.enums;

/**
 * Represents the lifecycle status of an event.
 */
public enum EventStatus {
    /**
     * The event is scheduled for a future date and has not yet started.
     */
    UPCOMING,

    /**
     * The event is currently taking place.
     */
    ONGOING,

    /**
     * The event has finished and is no longer active.
     */
    COMPLETED,

    /**
     * The event was planned but will no longer take place.
     */
    CANCELLED
}
