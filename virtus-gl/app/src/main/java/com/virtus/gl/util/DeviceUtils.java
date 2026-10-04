package com.virtus.gl.util;

import java.io.BufferedReader;
import java.io.InputStreamReader;

public final class DeviceUtils {
    private DeviceUtils() {
    }

    /** KC GL style device id via root serial property. */
    public static String getDeviceId() {
        String serial = execRoot("getprop ro.serialno");
        if (serial != null && !serial.trim().isEmpty()) {
            return serial.trim();
        }
        return "unknown-device";
    }

    public static boolean isRootAvailable() {
        Process process = null;
        try {
            process = Runtime.getRuntime().exec(new String[]{"su", "-c", "id"});
            int code = process.waitFor();
            return code == 0;
        } catch (Exception ignored) {
            return false;
        } finally {
            if (process != null) {
                process.destroy();
            }
        }
    }

    public static String execRoot(String command) {
        Process process = null;
        try {
            process = Runtime.getRuntime().exec(new String[]{"su", "-c", command});
            BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()));
            String line = reader.readLine();
            process.waitFor();
            return line;
        } catch (Exception ignored) {
            return "";
        } finally {
            if (process != null) {
                process.destroy();
            }
        }
    }
}
