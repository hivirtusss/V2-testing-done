package com.virtus.gl.auth;

public class AuthResult {
    public final boolean success;
    public final String message;
    public final UserProfile profile;

    public AuthResult(boolean success, String message, UserProfile profile) {
        this.success = success;
        this.message = message;
        this.profile = profile;
    }

    public static AuthResult ok(String message, UserProfile profile) {
        return new AuthResult(true, message, profile);
    }

    public static AuthResult fail(String message) {
        return new AuthResult(false, message, null);
    }
}
