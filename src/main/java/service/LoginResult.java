package service;

import models.AuthenticatedUser;

public class LoginResult {
    private final boolean success;
    private final AuthenticatedUser user; // null on failure
    private final String error;           // null on success

    private LoginResult(boolean success, AuthenticatedUser user, String error) {
        this.success = success;
        this.user = user;
        this.error = error;
    }

    public static LoginResult success(AuthenticatedUser user) {
        return new LoginResult(true, user, null);
    }

    public static LoginResult failure(String error) {
        return new LoginResult(false, null, error);
    }

    public boolean isSuccess() { return success; }
    public AuthenticatedUser getUser() { return user; }
    public String getError() { return error; }
}