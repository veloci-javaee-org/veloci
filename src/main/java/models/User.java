	package models;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import enums.RoleEnum;

public class User {
	private int id;
	private String username;
	private String password;
	private RoleEnum role;
	private LocalDateTime registrationDate = LocalDateTime.now();
	
	public User() {
		
	}

	public User(int id, String username, String password, RoleEnum role) {
		super();
		this.id = id;
		this.username = username;
		this.password = password;
		this.role = role;
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public RoleEnum getRole() {
		return role;
	}

	public void setRole(RoleEnum role) {
		this.role = role;
	}
	
	public LocalDateTime getRegistrationDate() {
		return registrationDate;
	}
	
	public void setRegistrationDate(LocalDateTime date) {
		this.registrationDate = date;
	}
	
	public String getFormattedRegistrationDate() {
	    if (this.registrationDate == null) {
	        return "Unknown";
	    }
	    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd MMM yyyy, hh:mm a");
	    return this.registrationDate.format(formatter);
	}
}