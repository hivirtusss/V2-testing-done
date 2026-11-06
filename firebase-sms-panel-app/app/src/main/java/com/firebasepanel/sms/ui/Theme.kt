package com.firebasepanel.sms.ui

import androidx.compose.material3.ColorScheme
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Typography
import androidx.compose.material3.darkColorScheme
import androidx.compose.runtime.Composable
import androidx.compose.ui.graphics.Color

/** Virtus-style dark panel: deep navy, orange/yellow accents, green online. */
private val Bg = Color(0xFF12161F)
private val Surface = Color(0xFF1A2030)
private val Surface2 = Color(0xFF252D42)
private val Orange = Color(0xFFFF8C32)
private val Yellow = Color(0xFFFFD54F)
private val Green = Color(0xFF4ADE80)
private val Blue = Color(0xFF64B5F6)
private val Red = Color(0xFFFF6B6B)
private val OnBg = Color(0xFFF5F5F5)
private val OnMuted = Color(0xFF9CA3AF)

object VirtusColors {
    val bg = Bg
    /** Bright panel background (yellow Virtus reference) */
    val panelYellow = Color(0xFFFFD400)
    val card = Surface2
    val smsCardWhite = Color(0xFFF8F8F8)
    val msgGreen = Color(0xFF2E7D32)
    val labelBlue = Color(0xFF1565C0)
    val orange = Orange
    val yellow = Yellow
    val green = Green
    val blue = Blue
    val red = Red
    val onMuted = OnMuted
}

private val Scheme: ColorScheme =
    darkColorScheme(
        primary = Orange,
        onPrimary = Color(0xFF2A1200),
        secondary = Yellow,
        onSecondary = Color(0xFF2A2500),
        tertiary = Green,
        onTertiary = Color(0xFF002106),
        background = Bg,
        onBackground = OnBg,
        surface = Surface,
        onSurface = OnBg,
        surfaceVariant = Surface2,
        onSurfaceVariant = OnMuted,
        outline = Color(0xFF3D4A63),
        error = Red,
        onError = Color.White,
    )

@Composable
fun FirebasePanelTheme(content: @Composable () -> Unit) {
    MaterialTheme(
        colorScheme = Scheme,
        typography = Typography(),
        content = content,
    )
}
