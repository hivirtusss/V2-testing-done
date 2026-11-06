package com.firebasepanel.sms.ui

import androidx.compose.material3.ColorScheme
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Typography
import androidx.compose.material3.darkColorScheme
import androidx.compose.runtime.Composable
import androidx.compose.ui.graphics.Color

private val Bg = Color(0xFF0F1419)
private val Surface = Color(0xFF1A2332)
private val Surface2 = Color(0xFF243044)
private val Accent = Color(0xFF4CAF93)
private val Accent2 = Color(0xFF64B5F6)
private val OnBg = Color(0xFFE8EAED)
private val OnMuted = Color(0xFF9AA0A6)

private val Scheme: ColorScheme =
    darkColorScheme(
        primary = Accent,
        onPrimary = Color(0xFF003829),
        secondary = Accent2,
        onSecondary = Color(0xFF002340),
        tertiary = Color(0xFFFFB74D),
        background = Bg,
        onBackground = OnBg,
        surface = Surface,
        onSurface = OnBg,
        surfaceVariant = Surface2,
        onSurfaceVariant = OnMuted,
        outline = Color(0xFF3D4F66),
    )

@Composable
fun FirebasePanelTheme(content: @Composable () -> Unit) {
    MaterialTheme(
        colorScheme = Scheme,
        typography = Typography(),
        content = content,
    )
}
