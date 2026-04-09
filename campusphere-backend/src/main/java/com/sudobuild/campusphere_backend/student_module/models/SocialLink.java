package com.sudobuild.campusphere_backend.student_module.models;

import com.sudobuild.campusphere_backend.student_module.enums.SocialMediaPlatform;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Entity
@Table(name = "social_link")
public class SocialLink {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private String id;
    @ManyToOne
    @JoinColumn(name = "student_id")
    private Student student;
    private String url;
    @Enumerated(EnumType.STRING)
    private SocialMediaPlatform platform;

}