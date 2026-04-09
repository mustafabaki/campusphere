package com.sudobuild.campusphere_backend.student_module.models;

import com.sudobuild.campusphere_backend.student_module.enums.Department;
import jakarta.persistence.*;
import lombok.Data;

import java.util.ArrayList;
import java.util.List;

@Entity
@Data
@Table(name ="student")
public class Student {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private String id;
    private String name;
    private String surname;
    private String email;
    private String phone;
    private String profilePictureURL;
    @Enumerated(EnumType.STRING)
    private Department department;
    @OneToMany(fetch = FetchType.EAGER, mappedBy = "leader", cascade = CascadeType.ALL)
    private List<StudentClub> enrolledClubs = new ArrayList<>();

    @OneToMany(fetch = FetchType.EAGER, mappedBy = "student")
    private List<SocialLink> socialLinks = new ArrayList<>();




}
