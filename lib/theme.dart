import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Brand colors for MilkMart
const Color primaryBlue = Color(0xFF1741CC);
const Color lightBlue = Color(0xFF55ABEC);
const Color milkWhite = Color(0xFFF8F9FF);
const Color creamColor = Color(0xFFFFF8E1);

// Gradient definitions
LinearGradient get primaryGradient => const LinearGradient(
  colors: [primaryBlue, lightBlue],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

ThemeData get lightTheme => ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.light(
    primary: primaryBlue,
    secondary: lightBlue,
    tertiary: const Color(0xFF8BB4F0),
    surface: milkWhite,
    error: const Color(0xFFFF5963),
    onPrimary: const Color(0xFFFFFFFF),
    onSecondary: const Color(0xFF15161E),
    onTertiary: const Color(0xFF15161E),
    onSurface: const Color(0xFF15161E),
    onError: const Color(0xFFFFFFFF),
    outline: const Color(0xFFD0D9E2),
    background: Colors.white,
  ),
  brightness: Brightness.light,
  textTheme: TextTheme(
    displayLarge: GoogleFonts.poppins(
      fontSize: 57.0,
      fontWeight: FontWeight.bold,
      color: primaryBlue,
    ),
    displayMedium: GoogleFonts.poppins(
      fontSize: 45.0,
      fontWeight: FontWeight.bold,
      color: primaryBlue,
    ),
    displaySmall: GoogleFonts.poppins(
      fontSize: 36.0,
      fontWeight: FontWeight.w600,
      color: primaryBlue,
    ),
    headlineLarge: GoogleFonts.poppins(
      fontSize: 32.0,
      fontWeight: FontWeight.bold,
      color: primaryBlue,
    ),
    headlineMedium: GoogleFonts.poppins(
      fontSize: 24.0,
      fontWeight: FontWeight.w600,
      color: primaryBlue,
    ),
    headlineSmall: GoogleFonts.poppins(
      fontSize: 22.0,
      fontWeight: FontWeight.w600,
      color: primaryBlue,
    ),
    titleLarge: GoogleFonts.poppins(
      fontSize: 22.0,
      fontWeight: FontWeight.w500,
      color: Colors.black87,
    ),
    titleMedium: GoogleFonts.poppins(
      fontSize: 18.0,
      fontWeight: FontWeight.w500,
      color: Colors.black87,
    ),
    titleSmall: GoogleFonts.poppins(
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
      color: Colors.black87,
    ),
    labelLarge: GoogleFonts.poppins(
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
      color: Colors.white,
    ),
    labelMedium: GoogleFonts.poppins(
      fontSize: 14.0,
      fontWeight: FontWeight.w500,
      color: Colors.white,
    ),
    labelSmall: GoogleFonts.poppins(
      fontSize: 12.0,
      fontWeight: FontWeight.w500,
      color: Colors.white,
    ),
    bodyLarge: GoogleFonts.poppins(
      fontSize: 16.0,
      fontWeight: FontWeight.normal,
      color: Colors.black87,
    ),
    bodyMedium: GoogleFonts.poppins(
      fontSize: 14.0,
      fontWeight: FontWeight.normal,
      color: Colors.black87,
    ),
    bodySmall: GoogleFonts.poppins(
      fontSize: 12.0,
      fontWeight: FontWeight.normal,
      color: Colors.black54,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: primaryBlue,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      elevation: 0,
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: primaryBlue,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      side: const BorderSide(color: primaryBlue, width: 1.5),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: primaryBlue,
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFFD0D9E2), width: 1),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFFD0D9E2), width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: lightBlue, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.red.shade300, width: 1),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.red.shade300, width: 2),
    ),
    hintStyle: GoogleFonts.poppins(fontSize: 14, color: Colors.black38),
  ),
  cardTheme: CardThemeData(
    color: Colors.white,
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    clipBehavior: Clip.antiAliasWithSaveLayer,
  ),
  chipTheme: ChipThemeData(
    backgroundColor: lightBlue.withOpacity(0.1),
    disabledColor: Colors.grey.shade200,
    selectedColor: lightBlue,
    secondarySelectedColor: primaryBlue,
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    labelStyle: GoogleFonts.poppins(
      fontSize: 14,
      color: primaryBlue,
      fontWeight: FontWeight.w500,
    ),
    secondaryLabelStyle: GoogleFonts.poppins(
      fontSize: 14,
      color: Colors.white,
      fontWeight: FontWeight.w500,
    ),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.white,
    elevation: 0,
    titleTextStyle: GoogleFonts.poppins(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: primaryBlue,
    ),
    iconTheme: const IconThemeData(color: primaryBlue),
  ),
);

ThemeData get darkTheme => ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.dark(
    primary: lightBlue,
    secondary: primaryBlue,
    tertiary: const Color(0xFF8BB4F0),
    surface: const Color(0xFF1A1C2A),
    error: const Color(0xFFFF5963),
    onPrimary: const Color(0xFF1A1C2A),
    onSecondary: const Color(0xFFE5E7EB),
    onTertiary: const Color(0xFFE5E7EB),
    onSurface: const Color(0xFFE5E7EB),
    onError: const Color(0xFFFFFFFF),
    outline: const Color(0xFF454965),
    background: const Color(0xFF121421),
  ),
  brightness: Brightness.dark,
  textTheme: TextTheme(
    displayLarge: GoogleFonts.poppins(
      fontSize: 57.0,
      fontWeight: FontWeight.bold,
      color: lightBlue,
    ),
    displayMedium: GoogleFonts.poppins(
      fontSize: 45.0,
      fontWeight: FontWeight.bold,
      color: lightBlue,
    ),
    displaySmall: GoogleFonts.poppins(
      fontSize: 36.0,
      fontWeight: FontWeight.w600,
      color: lightBlue,
    ),
    headlineLarge: GoogleFonts.poppins(
      fontSize: 32.0,
      fontWeight: FontWeight.bold,
      color: lightBlue,
    ),
    headlineMedium: GoogleFonts.poppins(
      fontSize: 24.0,
      fontWeight: FontWeight.w600,
      color: lightBlue,
    ),
    headlineSmall: GoogleFonts.poppins(
      fontSize: 22.0,
      fontWeight: FontWeight.w600,
      color: lightBlue,
    ),
    titleLarge: GoogleFonts.poppins(
      fontSize: 22.0,
      fontWeight: FontWeight.w500,
      color: Colors.white,
    ),
    titleMedium: GoogleFonts.poppins(
      fontSize: 18.0,
      fontWeight: FontWeight.w500,
      color: Colors.white,
    ),
    titleSmall: GoogleFonts.poppins(
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
      color: Colors.white,
    ),
    labelLarge: GoogleFonts.poppins(
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
      color: const Color(0xFF1A1C2A),
    ),
    labelMedium: GoogleFonts.poppins(
      fontSize: 14.0,
      fontWeight: FontWeight.w500,
      color: const Color(0xFF1A1C2A),
    ),
    labelSmall: GoogleFonts.poppins(
      fontSize: 12.0,
      fontWeight: FontWeight.w500,
      color: const Color(0xFF1A1C2A),
    ),
    bodyLarge: GoogleFonts.poppins(
      fontSize: 16.0,
      fontWeight: FontWeight.normal,
      color: Colors.white70,
    ),
    bodyMedium: GoogleFonts.poppins(
      fontSize: 14.0,
      fontWeight: FontWeight.normal,
      color: Colors.white70,
    ),
    bodySmall: GoogleFonts.poppins(
      fontSize: 12.0,
      fontWeight: FontWeight.normal,
      color: Colors.white60,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: lightBlue,
      foregroundColor: const Color(0xFF1A1C2A),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      elevation: 0,
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: lightBlue,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      side: const BorderSide(color: lightBlue, width: 1.5),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: lightBlue,
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFF252736),
    contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFF454965), width: 1),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFF454965), width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: lightBlue, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.red.shade300, width: 1),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.red.shade300, width: 2),
    ),
    hintStyle: GoogleFonts.poppins(fontSize: 14, color: Colors.white38),
  ),
  cardTheme: CardTheme(
    color: const Color(0xFF252736),
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    clipBehavior: Clip.antiAliasWithSaveLayer,
  ),
  chipTheme: ChipThemeData(
    backgroundColor: lightBlue.withOpacity(0.2),
    disabledColor: Colors.grey.shade800,
    selectedColor: lightBlue,
    secondarySelectedColor: primaryBlue,
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    labelStyle: GoogleFonts.poppins(
      fontSize: 14,
      color: lightBlue,
      fontWeight: FontWeight.w500,
    ),
    secondaryLabelStyle: GoogleFonts.poppins(
      fontSize: 14,
      color: const Color(0xFF1A1C2A),
      fontWeight: FontWeight.w500,
    ),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: const Color(0xFF121421),
    elevation: 0,
    titleTextStyle: GoogleFonts.poppins(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: lightBlue,
    ),
    iconTheme: const IconThemeData(color: lightBlue),
  ),
);
