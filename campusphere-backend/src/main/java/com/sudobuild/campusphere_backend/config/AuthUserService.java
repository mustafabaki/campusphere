package com.sudobuild.campusphere_backend.config;

import com.sudobuild.campusphere_backend.student_module.repositories.StudentRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

@Service
public class AuthUserService implements UserDetailsService {
    private final StudentRepository userRepository;

    @Autowired
    public AuthUserService(StudentRepository userRepository) {
        this.userRepository = userRepository;
    }


    @Override
    public UserDetails loadUserByUsername(String email) throws UsernameNotFoundException {
        /*User foundUser = userRepository.findByEmail(email);
        if(foundUser != null){
            var springUser = org.springframework.security.core.userdetails.User.withUsername(foundUser.getEmail())
                    .password(foundUser.getPassword())
                    .build();
            return springUser;
        }*/
        return null;
    }
}
