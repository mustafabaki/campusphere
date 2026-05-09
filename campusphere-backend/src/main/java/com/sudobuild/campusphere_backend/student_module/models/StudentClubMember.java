package com.sudobuild.campusphere_backend.student_module.models;

import com.sudobuild.campusphere_backend.student_module.enums.ClubRole;

import jakarta.persistence.*;
import lombok.Data;

@Entity
@Table(name = "student_club_members")
@Data
public class StudentClubMember {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private String id;

    @ManyToOne
    @JoinColumn(name = "student_id")
    private Student student;

    @ManyToOne
    @JoinColumn(name = "club_id")
    private StudentClub club;

    @Enumerated(EnumType.STRING)
    private ClubRole role; // e.g., "President", "Member"
}
