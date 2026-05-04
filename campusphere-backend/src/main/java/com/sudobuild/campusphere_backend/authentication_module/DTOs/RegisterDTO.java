package com.sudobuild.campusphere_backend.authentication_module.DTOs;

import com.sudobuild.campusphere_backend.authentication_module.enums.UserRole;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class RegisterDTO {
    private String email;
    private String password;
    private UserRole role;

}
