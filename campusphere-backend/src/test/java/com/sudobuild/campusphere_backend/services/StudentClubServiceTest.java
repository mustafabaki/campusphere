package com.sudobuild.campusphere_backend.services;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.transaction.annotation.Transactional;

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
    public void createStudentClubTest() {

    }
}
