package com.sudobuild.campusphere_backend.student_module.services;

import com.sudobuild.campusphere_backend.student_module.enums.ClubRole;
import com.sudobuild.campusphere_backend.student_module.models.StudentClub;
import com.sudobuild.campusphere_backend.student_module.models.StudentClubMember;

import java.util.List;

/**
 * Service interface for managing student clubs and their memberships.
 */
public interface StudentClubService {

    /**
     * Creates a new student club.
     *
     * @param studentClub the club entity to create
     * @return the created StudentClub entity
     */
    StudentClub createClub(StudentClub studentClub);

    /**
     * Updates an existing student club.
     *
     * @param id          the ID of the club to update
     * @param studentClub the updated club data
     * @return the updated StudentClub entity
     */
    StudentClub updateClub(String id, StudentClub studentClub);

    /**
     * Deletes a student club by its ID.
     *
     * @param id the ID of the club to delete
     */
    void deleteClub(String id);

    /**
     * Retrieves a student club by its ID.
     *
     * @param id the ID of the club to retrieve
     * @return the StudentClub entity if found
     */
    StudentClub getClubById(String id);

    /**
     * Retrieves all student clubs.
     *
     * @return a list of all StudentClub entities
     */
    List<StudentClub> getAllClubs();

    /**
     * Adds a student as a member to a club with a specific role.
     *
     * @param clubId    the ID of the club
     * @param studentId the ID of the student
     * @param role      the role of the student in the club
     * @return the created StudentClubMember entity
     */
    StudentClubMember addMember(String clubId, String studentId, ClubRole role);

    /**
     * Removes a student from a club.
     *
     * @param clubId    the ID of the club
     * @param studentId the ID of the student to remove
     */
    void removeMember(String clubId, String studentId);

    /**
     * Updates the role of a club member.
     *
     * @param id   the ID of the membership record (not the student ID)
     * @param role the new role for the member
     * @return the updated StudentClubMember entity
     */
    StudentClubMember updateClubMember(String id, ClubRole role);

    /**
     * Retrieves all members of a specific club.
     *
     * @param clubId the ID of the club
     * @return a list of membership records for the club
     */
    List<StudentClubMember> getMembersByClubId(String clubId);

    /**
     * Retrieves all club memberships for a specific student.
     *
     * @param studentId the ID of the student
     * @return a list of membership records for the student
     */
    List<StudentClub> getClubMembershipsByStudentId(String studentId);
}
