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
import org.springframework.test.context.ActiveProfiles;
import org.springframework.transaction.annotation.Transactional;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;

@SpringBootTest(properties = {
        "spring.datasource.url=jdbc:h2:mem:testdb;DB_CLOSE_DELAY=-1;MODE=MySQL",
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
}
