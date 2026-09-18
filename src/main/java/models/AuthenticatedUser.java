package models;

import enums.RoleEnum;

public class AuthenticatedUser {
    private String username;
    private String passwordHash; // only used internally by the service for comparison, never exposed to session
    private String name;
    private String email;
    private RoleEnum role;

    public AuthenticatedUser() {}

    public AuthenticatedUser(String username, String passwordHash, String name, String email, RoleEnum role) {
        this.username = username;
        this.passwordHash = passwordHash;
        this.name = name;
        this.email = email;
        this.role = role;
    }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getPasswordHash() { return passwordHash; }
    public void setPasswordHash(String passwordHash) { this.passwordHash = passwordHash; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public RoleEnum getRole() { return role; }
    public void setRole(RoleEnum role) { this.role = role; }
}