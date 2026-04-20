package com.sudobuild.campusphere_backend.auxiliary;

import java.time.Instant;
import java.time.LocalDateTime;

public record ApiResponse<T>(
        boolean success,
        String message,
        T data
) {
    public static <T> ApiResponse<T> success(T data) {
        return new ApiResponse<>(true, "The request was handled successfully.", data);
    }

    public static <T> ApiResponse<T> failure(String message) {
        return new ApiResponse<>(false, message, null);
    }
}