package com.sudobuild.campusphere_backend.config;

import com.sudobuild.campusphere_backend.authentication_module.models.CampusphereUser;
import com.sudobuild.campusphere_backend.authentication_module.repositories.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

@Service
public class AuthUserService implements UserDetailsService {
    private final UserRepository userRepository;

    @Autowired
    public AuthUserService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    @Override
    public UserDetails loadUserByUsername(String email) throws UsernameNotFoundException {
        CampusphereUser foundUser = userRepository.findByEmail(email);
        if (foundUser != null) {
            var springUser = User.withUsername(foundUser.getEmail())
                    .password(foundUser.getPassword())
                    .build();
            return springUser;
        }
        return null;
    }
}
