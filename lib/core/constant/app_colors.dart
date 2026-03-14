import 'package:flutter/material.dart';

/// Centralized color constants used across the app.
/// These serve as the single source of truth for color values
/// referenced by both [AppTheme] and non-widget services.
class AppColors {
  const AppColors._();

  // ── Brand / Seed ──────────────────────────────────────────
  static const Color primaryLight = Color(0xFF2563EB);
  static const Color primaryDark = Color(0xFF3B82F6);

  // ── Surfaces ──────────────────────────────────────────────
  static const Color surfaceLight = Color(0xFFF8FAFC);
  static const Color surfaceDark = Color(0xFF1E293B);
  static const Color scaffoldLight = Color(0xFFF1F5F9);
  static const Color scaffoldDark = Color(0xFF0F172A);

  // ── Semantic ──────────────────────────────────────────────
  static const Color errorLight = Color(0xFFEF4444);
  static const Color errorDark = Color(0xFFF87171);
  static const Color successLight = Color(0xFF10B981);
  static const Color successDark = Color(0xFF34D399);

  // ── Critical / Alert ──────────────────────────────────────
  static const Color criticalRed = Color(0xFFD32F2F);
  static const Color warningLight = Color(0xFFFF9800);
  static const Color warningDark = Color(0xFFFFB74D);

  // ── Chart Lines ────────────────────────────────────────────
  static const Color cpuChartLight = Color(0xFF2979FF);
  static const Color cpuChartDark = Color(0xFF448AFF);
  static const Color memoryChartLight = Color(0xFF7C4DFF);
  static const Color memoryChartDark = Color(0xFFB388FF);

  // ── Card border (dark mode) ───────────────────────────────
  static const Color cardBorderDark = Color(0xFF334155);
}
