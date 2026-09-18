package models;

public class Customer {
    private int id;   // customers.id (own PK)
    private User user;        // composition: Customer HAS a User (its login account)
    private String name;
    private String email;
    private String phone;
    private String address;

    public Customer() {
        this.user = new User(); // avoid null user by default
    }


    public Customer(int customerId, User user, String name, String email,
                     String phoneNumber, String address) {
        this.id = customerId;
        this.user = user;
        this.name = name;
        this.email = email;
        this.phone = phoneNumber;
        this.address = address;
    }

    public int getId() { return id; }
    public void setId(int customerId) { this.id = customerId; }

    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPhone() { return phone; }
    public void setPhone(String phoneNumber) { this.phone = phoneNumber; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public String getUsername() { return user.getUsername(); }
    public void setUsername(String username) { user.setUsername(username); }

    public String getPassword() { return user.getPassword(); }
    public void setPassword(String password) { user.setPassword(password); }

    public int getUserId() { return user.getId(); }
    public void setUserId(int userId) { user.setId(userId); }
}