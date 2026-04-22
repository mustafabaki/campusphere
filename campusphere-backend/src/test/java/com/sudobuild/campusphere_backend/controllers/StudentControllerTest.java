package com.sudobuild.campusphere_backend.controllers;

import com.sudobuild.campusphere_backend.auxiliary.ApiResponse;
import com.sudobuild.campusphere_backend.student_module.DTOs.StudentCreateDTO;
import com.sudobuild.campusphere_backend.student_module.DTOs.StudentResponseDTO;
import com.sudobuild.campusphere_backend.student_module.enums.Department;
import com.sudobuild.campusphere_backend.student_module.enums.SocialMediaPlatform;
import com.sudobuild.campusphere_backend.student_module.mappers.StudentMapper;
import com.sudobuild.campusphere_backend.student_module.repositories.StudentRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.web.server.LocalServerPort;
import org.springframework.test.context.TestPropertySource;
import org.springframework.test.web.servlet.client.RestTestClient;

import static org.junit.jupiter.api.Assertions.*;

import com.fasterxml.jackson.databind.ObjectMapper;

@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
@TestPropertySource(properties = {
        "spring.datasource.url=jdbc:h2:mem:testdb",
        "spring.datasource.driver-class-name=org.h2.Driver",
        "spring.datasource.username=sa",
        "spring.datasource.password=",
        "spring.jpa.database-platform=org.hibernate.dialect.H2Dialect",
        "spring.jpa.hibernate.ddl-auto=create-drop"
})
public class StudentControllerTest {

    @LocalServerPort
    private int port;

    RestTestClient client;
    ObjectMapper objectMapper = new ObjectMapper();
    @Autowired
    private StudentRepository studentRepository;

    @Autowired
    private StudentMapper studentMapper;

    @BeforeEach
    void setUp() {
        client = RestTestClient.bindToServer().baseUrl("http://localhost:" + port).build();
    }

    @Test
    void createStudent() {
        StudentCreateDTO studentCreateDTO = new StudentCreateDTO();
        studentCreateDTO.setName("Jane");
        studentCreateDTO.setSurname("Doe");
        studentCreateDTO.setEmail("jane@doe.com");
        studentCreateDTO.setDepartment(Department.BIOLOGY);
        studentCreateDTO.setProfilePictureURL("https://doe.com");

        client.post()
                .uri("/api/student/create")
                .body(studentCreateDTO)
                .exchange()
                .expectStatus()
                .isOk()
                .expectBody(ApiResponse.class)
                .value(response -> {
                    assertNotNull(response);
                    assertNotNull(response.data());

                    StudentResponseDTO student = objectMapper.convertValue(
                            response.data(), StudentResponseDTO.class);
                    assertEquals("Jane", student.getName());
                    assertEquals("Doe", student.getSurname());
                });
    }

    @Test
    void getStudentByEmail() {
        // create student
        StudentCreateDTO studentCreateDTO = new StudentCreateDTO();
        studentCreateDTO.setName("Jane");
        studentCreateDTO.setSurname("Doe");
        studentCreateDTO.setEmail("jane@doe.com");
        studentCreateDTO.setDepartment(Department.BIOLOGY);
        studentCreateDTO.setProfilePictureURL("https://doe.com");

        studentRepository.save(studentMapper.toStudent(studentCreateDTO));

        // get student
        client.get()
                .uri("/api/student/getStudentByEmail?email="
                        + studentCreateDTO.getEmail())
                .exchange()
                .expectStatus()
                .isOk()
                .expectBody(ApiResponse.class)
                .value(response -> {
                    assertNotNull(response);
                    assertNotNull(response.data());

                    StudentResponseDTO student = objectMapper.convertValue(
                            response.data(), StudentResponseDTO.class);
                    assertEquals("Jane", student.getName());
                    assertEquals("Doe", student.getSurname());
                    assertEquals(Department.BIOLOGY, student.getDepartment());
                });

    }

    @Test
    void deleteStudentById() {
        // create student
        StudentCreateDTO studentCreateDTO = new StudentCreateDTO();
        studentCreateDTO.setName("Mark");
        studentCreateDTO.setSurname("Smith");
        studentCreateDTO.setEmail("mark@smith.com");
        studentCreateDTO.setDepartment(Department.CHEMISTRY);
        studentCreateDTO.setProfilePictureURL("https://smith.com");

        var savedStudent = studentRepository.save(studentMapper.toStudent(studentCreateDTO));

        // delete student
        client.delete()
                .uri("/api/student/deleteStudentById?id=" + savedStudent.getId())
                .exchange()
                .expectStatus()
                .isOk()
                .expectBody(ApiResponse.class)
                .value(response -> {
                    assertNotNull(response);
                    assertNull(response.data());
                });
    }

    @Test
    void updateStudentById() {
        // create student
        StudentCreateDTO studentCreateDTO = new StudentCreateDTO();
        studentCreateDTO.setName("Alice");
        studentCreateDTO.setSurname("Johnson");
        studentCreateDTO.setEmail("alice@johnson.com");
        studentCreateDTO.setDepartment(Department.PHYSICS);
        studentCreateDTO.setProfilePictureURL("https://johnson.com");

        var savedStudent = studentRepository.save(studentMapper.toStudent(studentCreateDTO));

        // update student
        StudentCreateDTO updateDTO = new StudentCreateDTO();
        updateDTO.setName("Alice Updated");
        updateDTO.setSurname("Johnson Updated");
        updateDTO.setEmail("alice.updated@johnson.com");

        client.put()
                .uri("/api/student/updateStudentById?id=" + savedStudent.getId())
                .body(updateDTO)
                .exchange()
                .expectStatus()
                .isOk()
                .expectBody(ApiResponse.class)
                .value(response -> {
                    assertNotNull(response);
                    assertNotNull(response.data());

                    StudentResponseDTO updatedStudent = objectMapper.convertValue(
                            response.data(), StudentResponseDTO.class);
                    assertEquals("Alice Updated", updatedStudent.getName());
                    assertEquals("Johnson Updated", updatedStudent.getSurname());
                    assertEquals("alice.updated@johnson.com", updatedStudent.getEmail());
                });
    }

    @Test
    void updateStudentByIdNonExistent() {
        // update non-existent student
        StudentCreateDTO updateDTO = new StudentCreateDTO();
        updateDTO.setName("Non Existent");

        client.put()
                .uri("/api/student/updateStudentById?id=non-existent-id")
                .body(updateDTO)
                .exchange()
                .expectStatus()
                .isBadRequest()
                .expectBody(ApiResponse.class)
                .value(response -> {
                    assertNotNull(response);
                    assertNull(response.data());
                    assertEquals("Student not found with id: non-existent-id", response.message());
                });
    }

    @Test
    void addSocialLinkToStudent() {
        // create student
        StudentCreateDTO studentCreateDTO = new StudentCreateDTO();
        studentCreateDTO.setName("Bob");
        studentCreateDTO.setSurname("Builder");
        studentCreateDTO.setEmail("bob@builder.com");
        studentCreateDTO.setDepartment(Department.PHYSICS);
        studentCreateDTO.setProfilePictureURL("https://bob.com");

        var savedStudent = studentRepository.save(studentMapper.toStudent(studentCreateDTO));

        client.post()
                .uri(uriBuilder -> uriBuilder
                        .path("/api/student/addSocialLinkToStudent")
                        .queryParam("studentId", savedStudent.getId())
                        .queryParam("url", "https://github.com/bob")
                        .queryParam("platform", SocialMediaPlatform.GITHUB.toString())
                        .build())
                .exchange()
                .expectStatus()
                .isOk()
                .expectBody(ApiResponse.class)
                .value(response -> {
                    System.out.println(response);
                    assertNotNull(response);
                    assertNotNull(response.data());

                    StudentResponseDTO updatedStudent = objectMapper.convertValue(
                            response.data(), StudentResponseDTO.class);
                    assertEquals(1, updatedStudent.getSocialLinks().size());
                    assertEquals("https://github.com/bob", updatedStudent.getSocialLinks().get(0).getUrl());
                    assertEquals(SocialMediaPlatform.GITHUB, updatedStudent.getSocialLinks().get(0).getPlatform());
                });
    }
}
