package com.sudobuild.campusphere_backend.student_module.services.implementations;

import java.util.List;
import java.util.stream.Collectors;

import com.sudobuild.campusphere_backend.student_module.enums.ClubRole;
import com.sudobuild.campusphere_backend.student_module.models.Student;
import com.sudobuild.campusphere_backend.student_module.models.StudentClub;
import com.sudobuild.campusphere_backend.student_module.models.StudentClubMember;
import com.sudobuild.campusphere_backend.student_module.repositories.StudentClubMemberRepository;
import com.sudobuild.campusphere_backend.student_module.repositories.StudentClubRepository;
import com.sudobuild.campusphere_backend.student_module.repositories.StudentRepository;
import com.sudobuild.campusphere_backend.student_module.services.StudentClubService;

import org.springframework.stereotype.Service;

@Service
public class StudentClubServiceImpl implements StudentClubService {
    private final StudentClubRepository studentClubRepository;
    private final StudentRepository studentRepository;
    private final StudentClubMemberRepository studentClubMemberRepository;

    public StudentClubServiceImpl(StudentClubRepository studentClubRepository, StudentRepository studentRepository,
            StudentClubMemberRepository studentClubMemberRepository) {
        this.studentClubRepository = studentClubRepository;
        this.studentRepository = studentRepository;
        this.studentClubMemberRepository = studentClubMemberRepository;
    }

    @Override
    public StudentClub createClub(StudentClub studentClub) {
        try {
            return studentClubRepository.save(studentClub);
        } catch (Exception e) {
            throw new RuntimeException("Club cannot be created.");
        }
    }

    @Override
    public StudentClub updateClub(String id, StudentClub studentClub) {
        try {
            StudentClub existingClub = studentClubRepository.findById(id)
                    .orElseThrow(() -> new RuntimeException("Club not found with id: " + id));

            // Update fields if not null
            if (studentClub.getName() != null) {
                existingClub.setName(studentClub.getName());
            }
            if (studentClub.getDescription() != null) {
                existingClub.setDescription(studentClub.getDescription());
            }
            if (studentClub.getLogoURL() != null) {
                existingClub.setLogoURL(studentClub.getLogoURL());
            }

            return studentClubRepository.save(existingClub);

        } catch (Exception e) {
            throw new RuntimeException("Club cannot be updated.");
        }
    }

    @Override
    public void deleteClub(String id) {
        try {
            StudentClub existingClub = studentClubRepository.findById(id)
                    .orElseThrow(() -> new RuntimeException("Club not found with id: " + id));
            studentClubRepository.delete(existingClub);
        } catch (Exception e) {
            throw new RuntimeException("Club cannot be deleted.");
        }
    }

    @Override
    public StudentClub getClubById(String id) {
        try {
            return studentClubRepository.findById(id)
                    .orElseThrow(() -> new RuntimeException("Club not found with id: " + id));
        } catch (Exception e) {
            throw new RuntimeException("Club cannot be found.");
        }
    }

    @Override
    public List<StudentClub> getAllClubs() {
        try {
            return studentClubRepository.findAll();
        } catch (Exception e) {
            throw new RuntimeException("Clubs cannot be retrieved.");
        }
    }

    @Override
    public StudentClubMember addMember(String clubId, String studentId, ClubRole role) {
        try {
            StudentClub club = studentClubRepository.findById(clubId)
                    .orElseThrow(() -> new RuntimeException("Club not found with id: " + clubId));
            Student student = studentRepository.findById(studentId)
                    .orElseThrow(() -> new RuntimeException("Student not found with id: " + studentId));
            StudentClubMember studentClubMember = new StudentClubMember();
            studentClubMember.setClub(club);
            studentClubMember.setStudent(student);
            studentClubMember.setRole(role);
            return studentClubMemberRepository.save(studentClubMember);
        } catch (Exception e) {
            throw new RuntimeException("Member cannot be added.");
        }
    }

    @Override
    public void removeMember(String clubId, String studentId) {
        try {
            StudentClubMember studentClubMember = studentClubMemberRepository
                    .findByClubIdAndStudentId(clubId, studentId)
                    .orElseThrow(() -> new RuntimeException("Member not found"));
            studentClubMemberRepository.delete(studentClubMember);
        } catch (Exception e) {
            throw new RuntimeException("Member could not be found");
        }
    }

    @Override
    public StudentClubMember updateClubMember(String id, ClubRole role) {
        // TODO Auto-generated method stub
        throw new UnsupportedOperationException("Unimplemented method 'updateClubMember'");
    }

    @Override
    public List<StudentClubMember> getMembersByClubId(String clubId) {
        try {
            return studentClubMemberRepository.findAllByClubId(clubId);
        } catch (Exception e) {
            throw new RuntimeException("Members could not be retrieved for club: " + clubId);
        }
    }

    @Override
    public List<StudentClub> getClubMembershipsByStudentId(String studentId) {
        try {
            List<StudentClubMember> members = studentClubMemberRepository.findAllByStudentId(studentId);
            return members.stream().map(StudentClubMember::getClub).collect(Collectors.toList());
        } catch (Exception e) {
            throw new RuntimeException("Memberships could not be retrieved for student: " + studentId);
        }
    }

}
