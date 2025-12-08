import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// App Theme: Futuristic dark UI with neon accents
class AppTheme {
  // Color palette
  static const Color primaryNeon = Color(0xFF00F0FF); // Cyan neon
  static const Color secondaryNeon = Color(0xFFFF00E5); // Magenta neon
  static const Color accentNeon = Color(0xFF00FF88); // Green neon
  static const Color darkNavy = Color(0xFF0A0E27);
  static const Color deepNavy = Color(0xFF060A1F);
  static const Color glassBlue = Color(0xFF1A2347);
  static const Color glassHighlight = Color(0xFF2A3557);
  
  // Gradients
  static const LinearGradient navyGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [deepNavy, darkNavy, Color(0xFF0F1535)],
  );

  static const LinearGradient neonGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryNeon, secondaryNeon],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [glassBlue, glassHighlight],
    stops: [0.0, 1.0],
  );

  // Theme Data
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: primaryNeon,
      scaffoldBackgroundColor: darkNavy,
      
      // Color scheme
      colorScheme: const ColorScheme.dark(
        primary: primaryNeon,
        secondary: secondaryNeon,
        tertiary: accentNeon,
        surface: glassBlue,
        background: darkNavy,
        error: Color(0xFFFF4444),
        onPrimary: Colors.black,
        onSecondary: Colors.black,
        onSurface: Colors.white,
        onBackground: Colors.white,
      ),

      // Text theme
      textTheme: TextTheme(
        displayLarge: GoogleFonts.orbitron(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          letterSpacing: 1.2,
        ),
        displayMedium: GoogleFonts.orbitron(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          letterSpacing: 1.0,
        ),
        displaySmall: GoogleFonts.orbitron(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        headlineMedium: GoogleFonts.rajdhani(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        titleLarge: GoogleFonts.rajdhani(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
        titleMedium: GoogleFonts.rajdhani(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.white70,
        ),
        bodyLarge: GoogleFonts.rajdhani(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: Colors.white,
        ),
        bodyMedium: GoogleFonts.rajdhani(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: Colors.white70,
        ),
        labelLarge: GoogleFonts.rajdhani(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.white,
          letterSpacing: 0.5,
        ),
      ),

      // AppBar theme
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.orbitron(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: primaryNeon,
          letterSpacing: 1.5,
        ),
      ),

      // Card theme
      cardTheme: CardThemeData(
        color: glassBlue.withOpacity(0.3),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: primaryNeon.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),

      // Button themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),

      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: glassBlue.withOpacity(0.3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryNeon.withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryNeon.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryNeon, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFFF4444)),
        ),
        labelStyle: GoogleFonts.rajdhani(
          color: Colors.white70,
          fontSize: 14,
        ),
        hintStyle: GoogleFonts.rajdhani(
          color: Colors.white38,
          fontSize: 14,
        ),
      ),

      // Bottom navigation bar theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: glassBlue,
        selectedItemColor: primaryNeon,
        unselectedItemColor: Colors.white38,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),

      // Floating action button theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryNeon,
        foregroundColor: Colors.black,
        elevation: 8,
      ),

      // Icon theme
      iconTheme: const IconThemeData(
        color: primaryNeon,
        size: 24,
      ),

      // Divider theme
      dividerTheme: DividerThemeData(
        color: primaryNeon.withOpacity(0.2),
        thickness: 1,
      ),
    );
  }

  // Box decorations
  static BoxDecoration get glassCardDecoration {
    return BoxDecoration(
      gradient: cardGradient,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: primaryNeon.withOpacity(0.2),
        width: 1,
      ),
      boxShadow: [
        BoxShadow(
          color: primaryNeon.withOpacity(0.1),
          blurRadius: 20,
          spreadRadius: 0,
        ),
      ],
    );
  }

  static BoxDecoration get neonGlowDecoration {
    return BoxDecoration(
      gradient: neonGradient,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: primaryNeon.withOpacity(0.5),
          blurRadius: 20,
          spreadRadius: 2,
        ),
        BoxShadow(
          color: secondaryNeon.withOpacity(0.3),
          blurRadius: 30,
          spreadRadius: 0,
        ),
      ],
    );
  }

  // Text styles
  static TextStyle get neonTextStyle {
    return GoogleFonts.orbitron(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Colors.white,
      shadows: [
        Shadow(
          color: primaryNeon.withOpacity(0.8),
          blurRadius: 10,
        ),
      ],
    );
  }
}
