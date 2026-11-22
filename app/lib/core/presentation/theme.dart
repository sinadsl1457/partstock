// 블랙 + 그린 테마(디자인 3차 시안). 녹색은 강조(브랜드·선택·주 버튼·차트 선)에만, 오르내림은 따로(format.dart).
import 'package:flutter/material.dart';

abstract final class AppColors {
  static const bg = Color(0xFF0A0C0B);
  static const bar = Color(0xFF0E110F);
  static const surface = Color(0xFF121513);
  static const surfaceHi = Color(0xFF1A1F1C);
  static const line = Color(0xFF1E2320);
  static const lineHi = Color(0xFF2E3530);
  static const text = Color(0xFFEDF2EE);
  static const sub = Color(0xFFB7C0B9);
  static const muted = Color(0xFF8E978F);
  static const faint = Color(0xFF6B746D);
  static const accent = Color(0xFF7EE04B);
  static const onAccent = Color(0xFF0A0C0B);
  static const warn = Color(0xFFF5B74B);
}

ThemeData buildTheme() {
  const scheme = ColorScheme.dark(
    primary: AppColors.accent,
    onPrimary: AppColors.onAccent,
    secondary: AppColors.accent,
    onSecondary: AppColors.onAccent,
    surface: AppColors.bg,
    onSurface: AppColors.text,
    surfaceContainerHighest: AppColors.surface,
    outline: AppColors.lineHi,
    outlineVariant: AppColors.line,
    error: Color(0xFFFF6464),
  );
  final base = ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    fontFamily: 'SpaceGrotesk',
    brightness: Brightness.dark,
  );
  return base.copyWith(
    scaffoldBackgroundColor: AppColors.bg,
    textTheme: base.textTheme.apply(bodyColor: AppColors.text, displayColor: AppColors.text),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.bg,
      surfaceTintColor: Colors.transparent,
      foregroundColor: AppColors.text,
      elevation: 0,
    ),
    dividerTheme: const DividerThemeData(color: AppColors.line, space: 1, thickness: 1),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.bar,
      surfaceTintColor: Colors.transparent,
      indicatorColor: Colors.transparent,
      iconTheme: WidgetStateProperty.resolveWith(
        (s) => IconThemeData(color: s.contains(WidgetState.selected) ? AppColors.accent : AppColors.muted),
      ),
      labelTextStyle: WidgetStateProperty.resolveWith(
        (s) => TextStyle(
          fontSize: 11,
          fontWeight: s.contains(WidgetState.selected) ? FontWeight.w600 : FontWeight.w500,
          color: s.contains(WidgetState.selected) ? AppColors.accent : AppColors.muted,
        ),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.accent,
        foregroundColor: AppColors.onAccent,
        minimumSize: const Size.fromHeight(52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, fontFamily: 'SpaceGrotesk'),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.text,
        side: const BorderSide(color: AppColors.lineHi),
        minimumSize: const Size.fromHeight(52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, fontFamily: 'SpaceGrotesk'),
      ),
    ),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: AppColors.surfaceHi,
      contentTextStyle: TextStyle(color: AppColors.text, fontFamily: 'SpaceGrotesk'),
      behavior: SnackBarBehavior.floating,
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      dragHandleColor: AppColors.lineHi,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(22))),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(color: AppColors.accent),
    radioTheme: RadioThemeData(fillColor: WidgetStateProperty.all(AppColors.accent)),
    textSelectionTheme: const TextSelectionThemeData(cursorColor: AppColors.accent),
  );
}
