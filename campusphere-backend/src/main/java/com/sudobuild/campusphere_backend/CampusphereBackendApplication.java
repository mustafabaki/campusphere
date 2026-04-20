package com.sudobuild.campusphere_backend;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.security.autoconfigure.SecurityAutoConfiguration;

@SpringBootApplication(exclude = {SecurityAutoConfiguration.class})
public class CampusphereBackendApplication {

	public static void main(String[] args) {
		SpringApplication.run(CampusphereBackendApplication.class, args);
	}

}
