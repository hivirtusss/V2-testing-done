package com.virtus.gl.util;

import android.content.Context;
import android.content.SharedPreferences;

import com.virtus.gl.auth.UserProfile;

public class SessionStore {
    private static final String PREFS = "virtus_gl_session";

    private final SharedPreferences prefs;

    public SessionStore(Context context) {
        prefs = context.getSharedPreferences(PREFS, Context.MODE_PRIVATE);
    }

    public void saveCredentials(String username, String password) {
        prefs.edit()
                .putString("username", username)
                .putString("password", password)
                .apply();
    }

    public String getUsername() {
        return prefs.getString("username", "");
    }

    public String getPassword() {
        return prefs.getString("password", "");
    }

    public void saveProfile(UserProfile profile) {
        if (profile == null) {
            return;
        }
        prefs.edit()
                .putString("username", profile.username)
                .putLong("viptime", profile.viptime)
                .putInt("tier", profile.tier)
                .putString("tier_name", profile.tierName)
                .apply();
    }

    public long getVipTime() {
        return prefs.getLong("viptime", 0L);
    }

    public int getTier() {
        return prefs.getInt("tier", 1);
    }

    public String getTierName() {
        return prefs.getString("tier_name", "lite");
    }

    public void setTier(int tier, String tierName) {
        prefs.edit().putInt("tier", tier).putString("tier_name", tierName).apply();
    }

    public int getServerLine() {
        return prefs.getInt("server_line", 0);
    }

    public void setServerLine(int line) {
        prefs.edit().putInt("server_line", line).apply();
    }

    public void clearSession() {
        prefs.edit()
                .remove("username")
                .remove("password")
                .remove("viptime")
                .remove("tier")
                .remove("tier_name")
                .apply();
    }
}
