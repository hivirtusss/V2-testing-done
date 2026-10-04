package com.virtus.gl.auth;

public class UserProfile {
    public String username;
    public long viptime;
    public String deviceId;
    public int tier;
    public String tierName;

    public boolean isActive() {
        if (viptime <= 0) {
            return false;
        }
        long now = System.currentTimeMillis() / 1000L;
        return viptime > now;
    }
}
