package com.virtus.gl.util;

import java.util.Locale;
import java.util.concurrent.TimeUnit;

public final class TimeFormat {
    private TimeFormat() {
    }

    public static String remaining(long vipTimeSec) {
        long now = System.currentTimeMillis() / 1000L;
        long diff = vipTimeSec - now;
        if (diff <= 0) {
            return "Membership is not activated";
        }
        long days = TimeUnit.SECONDS.toDays(diff);
        long hours = TimeUnit.SECONDS.toHours(diff) % 24;
        long mins = TimeUnit.SECONDS.toMinutes(diff) % 60;
        return String.format(Locale.US, "%dd %dh %dm left", days, hours, mins);
    }
}
