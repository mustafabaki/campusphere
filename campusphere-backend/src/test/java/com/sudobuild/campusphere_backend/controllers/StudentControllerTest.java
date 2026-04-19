package com.sudobuild.campusphere_backend.controllers;


import com.sudobuild.campusphere_backend.auxiliary.ApiResponse;
import com.sudobuild.campusphere_backend.student_module.DTOs.StudentCreateDTO;
import com.sudobuild.campusphere_backend.student_module.DTOs.StudentResponseDTO;
import com.sudobuild.campusphere_backend.student_module.enums.Department;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
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
                    StudentResponseDTO student = objectMapper.convertValue(
                            response.data(), StudentResponseDTO.class
                    );
                    assertEquals("Jane", student.getName());
                    assertEquals("Doe", student.getSurname());
                });
    }
}