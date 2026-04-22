package com.sudobuild.campusphere_backend.student_module.DTOs;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.sudobuild.campusphere_backend.student_module.enums.Department;
import com.sudobuild.campusphere_backend.student_module.models.SocialLink;
import com.sudobuild.campusphere_backend.student_module.models.StudentClub;
import lombok.Getter;
import lombok.Setter;

import java.util.ArrayList;
import java.util.List;

@Getter
@Setter
public class StudentResponseDTO {
    private String id;
    private String name;
    private String surname;
    private String email;
    private String phone;
    private String profilePictureURL;
    private Department department;
    @JsonIgnoreProperties("leader")
    private List<StudentClub> enrolledClubs = new ArrayList<>();
    @JsonIgnoreProperties("student")
    private List<SocialLink> socialLinks = new ArrayList<>();
}
