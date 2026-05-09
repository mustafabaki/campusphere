package com.sudobuild.campusphere_backend.services;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertNull;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;

import java.util.List;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.transaction.annotation.Transactional;

import com.sudobuild.campusphere_backend.student_module.enums.ClubRole;
import com.sudobuild.campusphere_backend.student_module.enums.Department;
import com.sudobuild.campusphere_backend.student_module.models.Student;
import com.sudobuild.campusphere_backend.student_module.models.StudentClub;
import com.sudobuild.campusphere_backend.student_module.models.StudentClubMember;
import com.sudobuild.campusphere_backend.student_module.repositories.StudentClubMemberRepository;
import com.sudobuild.campusphere_backend.student_module.repositories.StudentClubRepository;
import com.sudobuild.campusphere_backend.student_module.repositories.StudentRepository;
import com.sudobuild.campusphere_backend.student_module.services.StudentClubService;

@SpringBootTest(properties = {
        "spring.datasource.url=jdbc:h2:mem:testdb;DB_CLOSE_DELAY=-1;MODE=MySQL",
        "spring.datasource.username=sa",
        "spring.datasource.password=",
        "spring.datasource.driver-class-name=org.h2.Driver"
})
@Transactional
public class StudentClubServiceTest {
    @Autowired
    private StudentClubService studentClubService;

    @Autowired
    private StudentClubRepository studentClubRepository;

    @Autowired
    private StudentRepository studentRepository;

    @Autowired
    private StudentClubMemberRepository studentClubMemberRepository;

    @Test
    public void shouldCreateStudentClubTest() {
        // Arrange
        StudentClub studentClub = new StudentClub();
        studentClub.setName("Chess Club");
        studentClub.setDescription("Chess Club");
        studentClub.setLogoURL("https://example.com/chess_club.jpg");

        // Act
        StudentClub createdClub = studentClubService.createClub(studentClub);

        // Assert
        assertNotNull(createdClub);
        assertEquals(studentClub.getId(), createdClub.getId());
        assertEquals(studentClub.getName(), createdClub.getName());
        assertEquals(studentClub.getDescription(), createdClub.getDescription());
        assertEquals(studentClub.getLogoURL(), createdClub.getLogoURL());
    }

    @Test
    public void shouldUpdateStudentClubTest() {
        // Arrange
        StudentClub studentClub = new StudentClub();
        studentClub.setName("Chess Club");
        studentClub.setDescription("Chess Club");
        studentClub.setLogoURL("https://example.com/chess_club.jpg");
        StudentClub savedClub = studentClubRepository.save(studentClub);

        // update the name of savedClub
        savedClub.setName("Chess Club Updated");

        // Act
        StudentClub updatedClub = studentClubService.updateClub(savedClub.getId(), savedClub);

        // Assert
        assertNotNull(updatedClub);
        assertEquals(studentClub.getId(), updatedClub.getId());
        assertEquals(updatedClub.getName(), "Chess Club Updated");
        assertEquals(studentClub.getDescription(), updatedClub.getDescription());
        assertEquals(studentClub.getLogoURL(), updatedClub.getLogoURL());
    }



    @Test
    public void shouldDeleteStudentClubTest() {
        // Arrange
        StudentClub studentClub = new StudentClub();
        studentClub.setName("Chess Club");
        studentClub.setDescription("Chess Club");
        studentClub.setLogoURL("https://example.com/chess_club.jpg");
        StudentClub savedClub = studentClubRepository.save(studentClub);

        // Act
        studentClubService.deleteClub(savedClub.getId());

        // Assert
        StudentClub deletedClub = studentClubRepository.findById(savedClub.getId())
                .orElse(null);
        assertNull(deletedClub);
    }


    @Test
    public void shouldGetAllStudentClubsTest() {
        // Arrange
        StudentClub studentClub = new StudentClub();
        studentClub.setName("Chess Club");
        studentClub.setDescription("Chess Club");
        studentClub.setLogoURL("https://example.com/chess_club.jpg");
        studentClubRepository.save(studentClub);

        // Act
        List<StudentClub> allClubs = studentClubService.getAllClubs();

        // Assert
        assertNotNull(allClubs);
        assertEquals(1, allClubs.size());
        assertEquals(studentClub.getId(), allClubs.get(0).getId());
        assertEquals(studentClub.getName(), allClubs.get(0).getName());
        assertEquals(studentClub.getDescription(), allClubs.get(0).getDescription());
        assertEquals(studentClub.getLogoURL(), allClubs.get(0).getLogoURL());
    }

    @Test
    public void shouldAddMemberTest() {
        // Arrange
        StudentClub studentClub = new StudentClub();
        studentClub.setName("Chess Club");
        StudentClub savedClub = studentClubRepository.save(studentClub);

        Student student = new Student();
        student.setName("John");
        student.setSurname("Doe");
        student.setEmail("john.doe@example.com");
        student.setDepartment(Department.COMPUTER_ENGINEERING);
        Student savedStudent = studentRepository.save(student);

        // Act
        StudentClubMember membership = studentClubService.addMember(savedClub.getId(), savedStudent.getId(), ClubRole.MEMBER);

        // Assert
        assertNotNull(membership);
        assertEquals(savedClub.getId(), membership.getClub().getId());
        assertEquals(savedStudent.getId(), membership.getStudent().getId());
        assertEquals(ClubRole.MEMBER, membership.getRole());
    }

    @Test
    public void shouldRemoveMemberTest() {
        // Arrange
        StudentClub studentClub = new StudentClub();
        studentClub.setName("Chess Club");
        StudentClub savedClub = studentClubRepository.save(studentClub);

        Student student = new Student();
        student.setName("John");
        student.setSurname("Doe");
        student.setEmail("john.doe@example.com");
        student.setDepartment(Department.COMPUTER_ENGINEERING);
        Student savedStudent = studentRepository.save(student);

        studentClubService.addMember(savedClub.getId(), savedStudent.getId(), ClubRole.MEMBER);

        // Act
        studentClubService.removeMember(savedClub.getId(), savedStudent.getId());

        // Assert
        assertTrue(studentClubMemberRepository.findByClubIdAndStudentId(savedClub.getId(), savedStudent.getId()).isEmpty());
    }

    @Test
    public void shouldGetMembersByClubIdTest() {
        // Arrange
        StudentClub studentClub = new StudentClub();
        studentClub.setName("Chess Club");
        StudentClub savedClub = studentClubRepository.save(studentClub);

        Student student1 = new Student();
        student1.setName("John");
        student1.setSurname("Doe");
        student1.setEmail("john.doe@example.com");
        student1.setDepartment(Department.COMPUTER_ENGINEERING);
        Student savedStudent1 = studentRepository.save(student1);

        Student student2 = new Student();
        student2.setName("Jane");
        student2.setSurname("Doe");
        student2.setEmail("jane.doe@example.com");
        student2.setDepartment(Department.COMPUTER_ENGINEERING);
        Student savedStudent2 = studentRepository.save(student2);

        studentClubService.addMember(savedClub.getId(), savedStudent1.getId(), ClubRole.MEMBER);
        studentClubService.addMember(savedClub.getId(), savedStudent2.getId(), ClubRole.PRESIDENT);

        // Act
        List<StudentClubMember> members = studentClubService.getMembersByClubId(savedClub.getId());

        // Assert
        assertNotNull(members);
        assertEquals(2, members.size());
    }

    @Test
    public void shouldGetClubMembershipsByStudentIdTest() {
        // Arrange
        StudentClub club1 = new StudentClub();
        club1.setName("Chess Club");
        StudentClub savedClub1 = studentClubRepository.save(club1);

        StudentClub club2 = new StudentClub();
        club2.setName("Drama Club");
        StudentClub savedClub2 = studentClubRepository.save(club2);

        Student student = new Student();
        student.setName("John");
        student.setSurname("Doe");
        student.setEmail("john.doe@example.com");
        student.setDepartment(Department.COMPUTER_ENGINEERING);
        Student savedStudent = studentRepository.save(student);

        studentClubService.addMember(savedClub1.getId(), savedStudent.getId(), ClubRole.MEMBER);
        studentClubService.addMember(savedClub2.getId(), savedStudent.getId(), ClubRole.MEMBER);

        // Act
        List<StudentClub> memberships = studentClubService.getClubMembershipsByStudentId(savedStudent.getId());

        // Assert
        assertNotNull(memberships);
        assertEquals(2, memberships.size());
        assertTrue(memberships.stream().anyMatch(c -> c.getId().equals(savedClub1.getId())));
        assertTrue(memberships.stream().anyMatch(c -> c.getId().equals(savedClub2.getId())));
    }

    @Test
    public void shouldThrowExceptionWhenUpdateClubMemberTest() {
        // Act & Assert
        assertThrows(UnsupportedOperationException.class, () -> {
            studentClubService.updateClubMember("some-id", ClubRole.MEMBER);
        });
    }
}
