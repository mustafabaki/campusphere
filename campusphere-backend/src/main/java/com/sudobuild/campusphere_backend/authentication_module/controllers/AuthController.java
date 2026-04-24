package com.sudobuild.campusphere_backend.authentication_module.controllers;

import java.time.Instant;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.oauth2.jose.jws.MacAlgorithm;
import org.springframework.security.oauth2.jwt.JwsHeader;
import org.springframework.security.oauth2.jwt.JwtClaimsSet;
import org.springframework.security.oauth2.jwt.JwtEncoderParameters;
import org.springframework.security.oauth2.jwt.NimbusJwtEncoder;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.nimbusds.jose.jwk.source.ImmutableSecret;
import com.sudobuild.campusphere_backend.authentication_module.DTOs.LoginDTO;
import com.sudobuild.campusphere_backend.authentication_module.DTOs.RegisterDTO;
import com.sudobuild.campusphere_backend.authentication_module.models.CampusphereUser;
import com.sudobuild.campusphere_backend.authentication_module.repositories.UserRepository;
import com.sudobuild.campusphere_backend.auxiliary.ApiResponse;

@RestController
@RequestMapping("/api/auth")
@CrossOrigin
public class AuthController {
    private final UserRepository userRepository;
    private final AuthenticationManager authenticationManager;

    @Value("${security.jwt.issuer}")
    private String jwtIssuer;

    @Value("${security.jwt.secret-key}")
    private String jwtSecretKey;

    public AuthController(UserRepository userRepository, AuthenticationManager authenticationManager) {
        this.userRepository = userRepository;
        this.authenticationManager = authenticationManager;
    }

    /**
     * Authenticates a user and returns a JWT token if successful.
     *
     * @param loginCredentials The DTO containing the user's email and password.
     * @return A ResponseEntity containing the JWT token on success, or an error
     *         message on failure.
     */
    @GetMapping("/login")
    public ResponseEntity<?> login(@RequestBody LoginDTO loginCredentials) {
        try {
            authenticationManager.authenticate(
                    new UsernamePasswordAuthenticationToken(loginCredentials.getEmail(),
                            loginCredentials.getPassword()));

            CampusphereUser foundUser = userRepository.findByEmail(loginCredentials.getEmail());

            String jwtToken = createJwtToken(foundUser);

            return ResponseEntity.ok(ApiResponse.success(jwtToken));
        } catch (Exception e) {
            return ResponseEntity.status(401).body(ApiResponse.failure("Invalid credentials"));
        }
    }

    /**
     * Registers a new user in the system.
     *
     * @param registerCredentials The DTO containing the new user's email, password,
     *                            and role.
     * @return A ResponseEntity indicating success or failure of the registration.
     */
    @PostMapping("/register")
    public ResponseEntity<?> register(@RequestBody RegisterDTO registerCredentials) {

        try {

            if (userRepository.findByEmail(registerCredentials.getEmail()) != null) {
                return ResponseEntity.status(400).body(ApiResponse.failure("User with this email already exists"));
            }

            CampusphereUser newUser = new CampusphereUser();
            newUser.setEmail(registerCredentials.getEmail());
            newUser.setPassword(registerCredentials.getPassword());
            newUser.setRole(registerCredentials.getRole());
            userRepository.save(newUser);

            return ResponseEntity.ok(ApiResponse.success("User registered successfully"));

        } catch (Exception e) {
            return ResponseEntity.status(500).body(ApiResponse.failure(e.getMessage()));
        }

    }

    /**
     * Creates a JSON Web Token (JWT) for the authenticated user.
     *
     * @param foundUser The user for whom the token is being created.
     * @return A signed JWT token as a String.
     */
    private String createJwtToken(CampusphereUser foundUser) {
        Instant now = Instant.now();

        JwtClaimsSet claims = JwtClaimsSet.builder()
                .issuer(jwtIssuer)
                .issuedAt(now)
                .expiresAt(now.plusSeconds(24 * 3600))
                .subject(foundUser.getEmail())
                .claim("role", foundUser.getRole().name())
                .build();

        var encoder = new NimbusJwtEncoder(new ImmutableSecret<>(jwtSecretKey.getBytes()));
        var params = JwtEncoderParameters.from(JwsHeader.with(MacAlgorithm.HS256).build(), claims);

        return encoder.encode(params).getTokenValue();
    }

}