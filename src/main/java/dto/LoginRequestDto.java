package dto;

public class LoginRequestDto {
    private String identifier; // can be either a username (admins) or an email (customers)
    private String password;

    public LoginRequestDto() {}

    public LoginRequestDto(String identifier, String password) {
        this.identifier = identifier;
        this.password = password;
    }

    public String getIdentifier() { return identifier; }
    public void setIdentifier(String identifier) { this.identifier = identifier; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
}