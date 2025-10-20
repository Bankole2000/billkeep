import 'package:flutter/material.dart';

class AppColors {
  // --- Light theme colors ---
  static const light = AppColorScheme(
    text: Color(0xFF1A1A1A),
    textInverse: Color(0xFFF2F2F2),
    textMute: Colors.black54,
    primary: Color(0xFF161618),
    background: Color(0xFFFFFFFF),
    surface: Color(0xFFF6F6F6),
    accent: Color(0xFF007AFF),
  );

  // --- Dark theme colors ---
  static const dark = AppColorScheme(
    text: Color(0xFFF2F2F2),
    textInverse: Color(0xFF1A1A1A),
    textMute: Colors.white54,
    primary: Color(0xFFEAEAEA),
    background: Color(0xFF000000),
    surface: Color(0xFF1C1C1E),
    accent: Color(0xFF0A84FF),
  );
}

/// Internal class that represents a color scheme.
class AppColorScheme {
  final Color text;
  final Color textInverse;
  final Color textMute;
  final Color primary;
  final Color background;
  final Color surface;
  final Color accent;

  final Color? brand;
  final Color? water;
  final Color? navy;
  final Color? earth;
  final Color? fire;
  final Color? air;
  final Color? electric;
  final Color? wave;

  const AppColorScheme({
    required this.primary,
    required this.background,
    required this.surface,
    required this.accent,
    required this.text,
    required this.textMute,
    required this.textInverse,
    this.brand = Colors.blueAccent,
    this.water = Colors.blueAccent,
    this.navy = Colors.indigo,
    this.earth = Colors.orangeAccent,
    this.fire = Colors.redAccent,
    this.air = Colors.tealAccent,
    this.electric = Colors.purpleAccent,
    this.wave = Colors.greenAccent,
  });
}
