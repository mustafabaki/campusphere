package com.sudobuild.campusphere_backend.student_module.models;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Entity
@Table(name = "student_club")
public class StudentClub {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private String id;
    private String name;
    private String logoURL;
    @ManyToOne
    @JoinColumn(name = "student_id")
    @JsonIgnoreProperties({"enrolledClubs", "socialLinks"})
    private Student leader;


}