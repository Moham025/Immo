import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color background = Color(0xFFF7F6F3);
  static const Color cardColor = Color(0xFFFFFFFF);
  static const Color textMain = Color(0xFF2B2B2B);
  static const Color textSecondary = Color(0xFF8A8A8A);
  static const Color accent = Color(0xFF5E8B7E);
  
  static const Color whatsapp = Color(0xFF25D366);
  
  static const Color statusDisponible = Color(0xFF5E8B7E);
  static const Color statusReserve = Color(0xFFE0A458);
  static const Color statusVendu = Color(0xFFB0B0B0);

  static ThemeData get lightTheme {
    return ThemeData(
      scaffoldBackgroundColor: background,
      primaryColor: accent,
      textTheme: GoogleFonts.poppinsTextTheme().apply(
        bodyColor: textMain,
        displayColor: textMain,
      ),
      cardTheme: CardThemeData(
        color: cardColor,
        elevation: 0, // We use custom soft shadows
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        elevation: 0,
        iconTheme: IconThemeData(color: textMain),
        titleTextStyle: TextStyle(color: textMain, fontSize: 20, fontWeight: FontWeight.w600),
      ),
    );
  }
}
