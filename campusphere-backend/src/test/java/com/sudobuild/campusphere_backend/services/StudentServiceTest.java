package com.sudobuild.campusphere_backend.services;

import com.sudobuild.campusphere_backend.student_module.DTOs.StudentCreateDTO;
import com.sudobuild.campusphere_backend.student_module.DTOs.StudentResponseDTO;
import com.sudobuild.campusphere_backend.student_module.enums.Department;
import com.sudobuild.campusphere_backend.student_module.mappers.StudentMapper;
import com.sudobuild.campusphere_backend.student_module.models.Student;
import com.sudobuild.campusphere_backend.student_module.repositories.StudentRepository;
import com.sudobuild.campusphere_backend.student_module.services.StudentService;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.transaction.annotation.Transactional;

import static org.junit.jupiter.api.Assertions.*;

@SpringBootTest(properties = {
        "spring.datasource.url=jdbc:h2:mem:testdb;DB_CLOSE_DELAY=-1;MODE=MySQL",
        "spring.datasource.username=sa",
        "spring.datasource.password=",
        "spring.datasource.driver-class-name=org.h2.Driver"
})
@Transactional
public class StudentServiceTest {
    @Autowired
    private StudentService studentService;

    @Autowired
    private StudentMapper studentMapper;

    @Autowired
    private StudentRepository studentRepository;


    @Test
    public void shouldSaveStudent() {
        // declare StudentCreateDTO instance
        StudentCreateDTO studentCreateDTO = new StudentCreateDTO();
        studentCreateDTO.setName("John Doe");
        studentCreateDTO.setEmail("john.doe@example.com");
        studentCreateDTO.setPhone("1234567890");
        studentCreateDTO.setProfilePictureURL("https://example.com/profile_picture.jpg");
        studentCreateDTO.setDepartment(Department.COMPUTER_ENGINEERING);

        // convert it to Student object
        Student student = studentMapper.toStudent(studentCreateDTO);
        Student savedStudent = studentRepository.save(student);

        // convert it back to StudentResponseDTO
        StudentResponseDTO studentResponseDTO = studentMapper.toStudentResponseDTO(savedStudent);
        assertNotNull(studentResponseDTO);
        assertEquals(studentResponseDTO.getId(), savedStudent.getId());
    }

    @Test
    public void shouldRetrieveStudentByEmail() {
        // Arrange
        Student student = new Student();
        student.setName("Jane Doe");
        student.setEmail("jane.doe@example.com");
        student.setPhone("9876543210");
        student.setProfilePictureURL("https://example.com/jane_profile.jpg");
        student.setDepartment(Department.MECHANICAL_ENGINEERING);
        studentRepository.save(student);

        // Act
        StudentResponseDTO retrievedStudent = studentService.getStudentByEmail("jane.doe@example.com");

        // Assert
        assertNotNull(retrievedStudent);
        assertEquals("Jane Doe", retrievedStudent.getName());
        assertEquals("jane.doe@example.com", retrievedStudent.getEmail());
    }

    @Test
    public void shouldDeleteStudentById() {
        // Arrange
        Student student = new Student();
        student.setName("Mark Smith");
        student.setEmail("mark.smith@example.com");
        student.setPhone("1122334455");
        student.setProfilePictureURL("https://example.com/mark_profile.jpg");
        student.setDepartment(Department.ELECTRICAL_ENGINEERING);
        Student savedStudent = studentRepository.save(student);

        // Act
        studentService.deleteStudent(savedStudent.getId());

        // Assert
        boolean exists = studentRepository.existsById(savedStudent.getId());
        assertFalse(exists);
    }

    @Test
    public void shouldUpdateStudentFields() {
        // Arrange
        Student student = new Student();
        student.setName("Alice Johnson");
        student.setEmail("alice.johnson@example.com");
        student.setPhone("1231231234");
        student.setProfilePictureURL("https://example.com/alice_profile.jpg");
        student.setDepartment(Department.CIVIL_ENGINEERING);
        Student savedStudent = studentRepository.save(student);

        StudentCreateDTO updateDTO = new StudentCreateDTO();
        updateDTO.setName("Alice Updated");
        updateDTO.setEmail("alice.updated@example.com");
        updateDTO.setPhone("9879879876");

        // Act
        StudentResponseDTO updatedStudent = studentService.updateStudent(savedStudent.getId(), updateDTO);

        // Assert
        assertNotNull(updatedStudent);
        assertEquals("Alice Updated", updatedStudent.getName());
        assertEquals("alice.updated@example.com", updatedStudent.getEmail());
        assertEquals("9879879876", updatedStudent.getPhone());
        assertEquals("https://example.com/alice_profile.jpg", updatedStudent.getProfilePictureURL());
        assertEquals(Department.CIVIL_ENGINEERING, updatedStudent.getDepartment());
    }

    @Test
    public void shouldThrowExceptionWhenUpdatingNonExistentStudent() {
        // Arrange
        String nonExistentId = "non-existent-id";
        StudentCreateDTO updateDTO = new StudentCreateDTO();
        updateDTO.setName("Non Existent");

        // Act & Assert
        RuntimeException exception = assertThrows(RuntimeException.class, () -> {
            studentService.updateStudent(nonExistentId, updateDTO);
        });
        assertEquals("Student not found with id: non-existent-id", exception.getMessage());
    }
}
