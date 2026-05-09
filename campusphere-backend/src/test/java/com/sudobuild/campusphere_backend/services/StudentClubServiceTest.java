package com.sudobuild.campusphere_backend.services;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertNull;

import java.util.List;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.transaction.annotation.Transactional;

import com.sudobuild.campusphere_backend.student_module.models.StudentClub;
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
}
