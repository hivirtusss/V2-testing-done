package com.virtus.gl.auth;

import com.google.gson.Gson;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.virtus.gl.BuildConfig;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.util.Locale;
import java.util.concurrent.TimeUnit;
import java.util.regex.Pattern;

import okhttp3.MediaType;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.RequestBody;
import okhttp3.Response;

/**
 * Virtus GL license backend (Firebase RTDB).
 * Same flow as KC GL: register -> recharge key -> login -> viptime check.
 */
public class VirtusAuthClient {
    private static final MediaType JSON = MediaType.get("application/json; charset=utf-8");
    private static final Pattern KEY_PATTERN = Pattern.compile(
            "^KEY-[A-F0-9]{4}-[A-F0-9]{4}-[A-F0-9]{4}-[A-F0-9]{4}$"
    );

    private final OkHttpClient http;
    private final Gson gson;
    private final String baseUrl;

    public VirtusAuthClient() {
        this(BuildConfig.FIREBASE_URL);
    }

    public VirtusAuthClient(String firebaseUrl) {
        baseUrl = firebaseUrl.replaceAll("/+$", "");
        gson = new Gson();
        http = new OkHttpClient.Builder()
                .connectTimeout(12, TimeUnit.SECONDS)
                .readTimeout(20, TimeUnit.SECONDS)
                .writeTimeout(20, TimeUnit.SECONDS)
                .build();
    }

    public AuthResult register(String username, String password, String deviceId) {
        String user = normalizeUser(username);
        if (user.isEmpty() || password == null || password.length() < 4) {
            return AuthResult.fail("Username/password invalid");
        }
        if (exists(user)) {
            return AuthResult.fail("Account already exists");
        }
        JsonObject payload = new JsonObject();
        payload.addProperty("password_hash", sha256(password));
        payload.addProperty("device_id", deviceId == null ? "" : deviceId);
        payload.addProperty("viptime", 0);
        payload.addProperty("tier", 1);
        payload.addProperty("created_at", nowSec());
        if (!putJson(path("accounts/" + user), payload)) {
            return AuthResult.fail("Register failed (network)");
        }
        return AuthResult.ok("succeed", loadProfile(user));
    }

    public AuthResult login(String username, String password, String deviceId) {
        String user = normalizeUser(username);
        JsonObject account = getJson(path("accounts/" + user));
        if (account == null) {
            return AuthResult.fail("Account not found");
        }
        String expected = stringVal(account, "password_hash");
        if (!sha256(password).equals(expected)) {
            return AuthResult.fail("Wrong password");
        }
        String bound = stringVal(account, "device_id");
        if (bound != null && !bound.isEmpty() && deviceId != null && !deviceId.isEmpty()
                && !bound.equals(deviceId)) {
            return AuthResult.fail("Account bound to another device. Unbind first.");
        }
        if (bound == null || bound.isEmpty()) {
            account.addProperty("device_id", deviceId == null ? "" : deviceId);
            putJson(path("accounts/" + user), account);
        }
        UserProfile profile = parseProfile(user, account);
        if (!profile.isActive()) {
            return AuthResult.fail("Membership not activated. Recharge first.");
        }
        return AuthResult.ok("succeed", profile);
    }

    public AuthResult recharge(String username, String cardKey) {
        String user = normalizeUser(username);
        String key = normalizeKey(cardKey);
        if (!KEY_PATTERN.matcher(key).matches()) {
            return AuthResult.fail("Invalid key format");
        }
        JsonObject account = getJson(path("accounts/" + user));
        if (account == null) {
            return AuthResult.fail("Account not found");
        }
        JsonObject keyNode = getJson(path("keys/" + key));
        if (keyNode == null) {
            return AuthResult.fail("Key not found");
        }
        if (!keyNode.has("active") || !keyNode.get("active").getAsBoolean()) {
            return AuthResult.fail("Key inactive");
        }
        if (keyNode.has("redeemed_by") && !keyNode.get("redeemed_by").isJsonNull()) {
            String redeemedBy = keyNode.get("redeemed_by").getAsString();
            if (!redeemedBy.isEmpty() && !redeemedBy.equals(user)) {
                return AuthResult.fail("Key already used");
            }
        }
        int days = keyNode.has("days") ? keyNode.get("days").getAsInt() : 30;
        long current = account.has("viptime") ? account.get("viptime").getAsLong() : 0L;
        long now = nowSec();
        long base = Math.max(current, now);
        long updated = base + (days * 86400L);
        account.addProperty("viptime", updated);
        if (!putJson(path("accounts/" + user), account)) {
            return AuthResult.fail("Recharge failed (network)");
        }
        JsonObject redeemed = new JsonObject();
        redeemed.addProperty("active", false);
        redeemed.addProperty("redeemed_by", user);
        redeemed.addProperty("redeemed_at", now);
        if (!putJson(path("keys/" + key), redeemed)) {
            return AuthResult.fail("Key update failed");
        }
        return AuthResult.ok("succeed", parseProfile(user, account));
    }

    public AuthResult unbind(String username) {
        String user = normalizeUser(username);
        JsonObject account = getJson(path("accounts/" + user));
        if (account == null) {
            return AuthResult.fail("Account not found");
        }
        long last = account.has("last_unbind_at") ? account.get("last_unbind_at").getAsLong() : 0L;
        long now = nowSec();
        if (last > 0 && now - last < 86400L) {
            return AuthResult.fail("Unbind allowed once every 24 hours");
        }
        long viptime = account.has("viptime") ? account.get("viptime").getAsLong() : 0L;
        if (viptime > now) {
            account.addProperty("viptime", Math.max(now, viptime - 7200L));
        }
        account.addProperty("device_id", "");
        account.addProperty("last_unbind_at", now);
        if (!putJson(path("accounts/" + user), account)) {
            return AuthResult.fail("Unbind failed");
        }
        return AuthResult.ok("succeed", parseProfile(user, account));
    }

    public UserProfile fetchProfile(String username) {
        JsonObject account = getJson(path("accounts/" + normalizeUser(username)));
        if (account == null) {
            return null;
        }
        return parseProfile(normalizeUser(username), account);
    }

    public boolean pingServerLine(int lineIndex) {
        // Reserved for multi-region endpoints; line 0 uses default FIREBASE_URL.
        return lineIndex >= 0 && lineIndex <= 2;
    }

    private boolean exists(String username) {
        return getJson(path("accounts/" + username)) != null;
    }

    private UserProfile parseProfile(String username, JsonObject account) {
        UserProfile profile = new UserProfile();
        profile.username = username;
        profile.viptime = account.has("viptime") ? account.get("viptime").getAsLong() : 0L;
        profile.deviceId = stringVal(account, "device_id");
        profile.tier = account.has("tier") ? account.get("tier").getAsInt() : 1;
        profile.tierName = tierName(profile.tier);
        return profile;
    }

    private UserProfile loadProfile(String username) {
        JsonObject account = getJson(path("accounts/" + username));
        if (account == null) {
            UserProfile empty = new UserProfile();
            empty.username = username;
            return empty;
        }
        return parseProfile(username, account);
    }

    private String tierName(int tier) {
        switch (tier) {
            case 2:
                return "standard";
            case 3:
                return "professional";
            default:
                return "lite";
        }
    }

    private JsonObject getJson(String url) {
        Request request = new Request.Builder().url(url + ".json").get().build();
        try (Response response = http.newCall(request).execute()) {
            if (response.code() == 404 || response.body() == null) {
                return null;
            }
            String body = response.body().string();
            if (body == null || body.equals("null") || body.trim().isEmpty()) {
                return null;
            }
            JsonElement parsed = gson.fromJson(body, JsonElement.class);
            if (parsed == null || !parsed.isJsonObject()) {
                return null;
            }
            return parsed.getAsJsonObject();
        } catch (IOException e) {
            return null;
        }
    }

    private boolean putJson(String url, JsonObject payload) {
        RequestBody body = RequestBody.create(gson.toJson(payload), JSON);
        Request request = new Request.Builder().url(url + ".json").put(body).build();
        try (Response response = http.newCall(request).execute()) {
            return response.isSuccessful();
        } catch (IOException e) {
            return false;
        }
    }

    private String path(String suffix) {
        return baseUrl + "/virtus_gl/" + suffix;
    }

    private static String normalizeUser(String username) {
        if (username == null) {
            return "";
        }
        return username.trim().toLowerCase(Locale.US);
    }

    private static String normalizeKey(String key) {
        if (key == null) {
            return "";
        }
        return key.trim().toUpperCase(Locale.US);
    }

    private static String stringVal(JsonObject obj, String key) {
        if (obj == null || !obj.has(key) || obj.get(key).isJsonNull()) {
            return "";
        }
        return obj.get(key).getAsString();
    }

    private static long nowSec() {
        return System.currentTimeMillis() / 1000L;
    }

    static String sha256(String input) {
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] hash = digest.digest(input.getBytes(StandardCharsets.UTF_8));
            StringBuilder sb = new StringBuilder();
            for (byte b : hash) {
                sb.append(String.format(Locale.US, "%02x", b));
            }
            return sb.toString();
        } catch (Exception e) {
            return "";
        }
    }
}
