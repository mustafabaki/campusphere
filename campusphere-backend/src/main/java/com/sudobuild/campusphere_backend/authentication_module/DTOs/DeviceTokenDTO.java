package com.sudobuild.campusphere_backend.authentication_module.DTOs;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class DeviceTokenDTO {
    private String token;
    private String email;
}
