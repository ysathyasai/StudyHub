  import 'package:flutter/material.dart';
  import 'package:google_fonts/google_fonts.dart';

  class LightModeColors {
    static const lightPrimary = Color(0xFF2563EB);
    static const lightOnPrimary = Color(0xFFFFFFFF);
    static const lightPrimaryContainer = Color(0xFFDEEAFF);
    static const lightOnPrimaryContainer = Color(0xFF001B3D);
    static const lightSecondary = Color(0xFF535E71);
    static const lightOnSecondary = Color(0xFFFFFFFF);
    static const lightTertiary = Color(0xFF6B5778);
    static const lightOnTertiary = Color(0xFFFFFFFF);
    static const lightError = Color(0xFFDC2626);
    static const lightOnError = Color(0xFFFFFFFF);
    static const lightErrorContainer = Color(0xFFFFEDED);
    static const lightOnErrorContainer = Color(0xFF410002);
    static const lightInversePrimary = Color(0xFF93BBFF);
    static const lightShadow = Color(0xFF000000);
    static const lightSurface = Color(0xFFFFFFFF);
    static const lightOnSurface = Color(0xFF1A1C1E);
    static const lightSurfaceVariant = Color(0xFFF8FAFC);
    static const lightOutline = Color(0xFFE8EDF2);
    static const lightAppBarBackground = Color(0xFFFFFFFF);
    static const lightCardBackground = Color(0xFFF8FAFC);
  }

  class DarkModeColors {
    static const darkPrimary = Color(0xFF93BBFF);
    static const darkOnPrimary = Color(0xFF003066);
    static const darkPrimaryContainer = Color(0xFF00458E);
    static const darkOnPrimaryContainer = Color(0xFFDEEAFF);
    static const darkSecondary = Color(0xFFBCC7DB);
    static const darkOnSecondary = Color(0xFF263141);
    static const darkTertiary = Color(0xFFD9BDE3);
    static const darkOnTertiary = Color(0xFF3E2845);
    static const darkError = Color(0xFFFFB4AB);
    static const darkOnError = Color(0xFF690005);
    static const darkErrorContainer = Color(0xFF93000A);
    static const darkOnErrorContainer = Color(0xFFFFDAD6);
    static const darkInversePrimary = Color(0xFF2563EB);
    static const darkShadow = Color(0xFF000000);
    static const darkSurface = Color(0xFF0F1419);
    static const darkOnSurface = Color(0xFFE3E5E8);
    static const darkSurfaceVariant = Color(0xFF1A1F26);
    static const darkOutline = Color(0xFF2A3340);
    static const darkAppBarBackground = Color(0xFF0F1419);
    static const darkCardBackground = Color(0xFF1A1F26);
  }

  class FontSizes {
    static const double displayLarge = 57.0;
    static const double displayMedium = 45.0;
    static const double displaySmall = 36.0;
    static const double headlineLarge = 32.0;
    static const double headlineMedium = 24.0;
    static const double headlineSmall = 22.0;
    static const double titleLarge = 22.0;
    static const double titleMedium = 18.0;
    static const double titleSmall = 16.0;
    static const double labelLarge = 16.0;
    static const double labelMedium = 14.0;
    static const double labelSmall = 12.0;
    static const double bodyLarge = 16.0;
    static const double bodyMedium = 14.0;
    static const double bodySmall = 12.0;
  }

  ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.light(
      primary: LightModeColors.lightPrimary,
      onPrimary: LightModeColors.lightOnPrimary,
      primaryContainer: LightModeColors.lightPrimaryContainer,
      onPrimaryContainer: LightModeColors.lightOnPrimaryContainer,
      secondary: LightModeColors.lightSecondary,
      onSecondary: LightModeColors.lightOnSecondary,
      tertiary: LightModeColors.lightTertiary,
      onTertiary: LightModeColors.lightOnTertiary,
      error: LightModeColors.lightError,
      onError: LightModeColors.lightOnError,
      errorContainer: LightModeColors.lightErrorContainer,
      onErrorContainer: LightModeColors.lightOnErrorContainer,
      inversePrimary: LightModeColors.lightInversePrimary,
      shadow: LightModeColors.lightShadow,
      surface: LightModeColors.lightSurface,
      onSurface: LightModeColors.lightOnSurface,
      surfaceContainerHighest: LightModeColors.lightSurfaceVariant,
      outline: LightModeColors.lightOutline,
    ),
    brightness: Brightness.light,
    scaffoldBackgroundColor: LightModeColors.lightSurface,
    cardColor: LightModeColors.lightCardBackground,
    appBarTheme: const AppBarTheme(
      backgroundColor: LightModeColors.lightAppBarBackground,
      foregroundColor: LightModeColors.lightOnSurface,
      elevation: 0,
      centerTitle: false,
    ),
    cardTheme: CardThemeData(
      color: LightModeColors.lightCardBackground,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: LightModeColors.lightPrimary,
        foregroundColor: LightModeColors.lightOnPrimary,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: LightModeColors.lightPrimary,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        side: const BorderSide(color: LightModeColors.lightOutline),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: LightModeColors.lightSurfaceVariant,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: LightModeColors.lightPrimary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: LightModeColors.lightError),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: LightModeColors.lightSurfaceVariant,
      selectedColor: LightModeColors.lightPrimaryContainer,
      labelStyle: GoogleFonts.inter(fontSize: 14),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: LightModeColors.lightSurface,
      selectedItemColor: LightModeColors.lightPrimary,
      unselectedItemColor: LightModeColors.lightSecondary,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
      selectedLabelStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
      unselectedLabelStyle: GoogleFonts.inter(fontSize: 12),
    ),
    textTheme: TextTheme(
      displayLarge: GoogleFonts.inter(
        fontSize: FontSizes.displayLarge,
        fontWeight: FontWeight.normal,
      ),
      displayMedium: GoogleFonts.inter(
        fontSize: FontSizes.displayMedium,
        fontWeight: FontWeight.normal,
      ),
      displaySmall: GoogleFonts.inter(
        fontSize: FontSizes.displaySmall,
        fontWeight: FontWeight.w600,
      ),
      headlineLarge: GoogleFonts.inter(
        fontSize: FontSizes.headlineLarge,
        fontWeight: FontWeight.normal,
      ),
      headlineMedium: GoogleFonts.inter(
        fontSize: FontSizes.headlineMedium,
        fontWeight: FontWeight.w500,
      ),
      headlineSmall: GoogleFonts.inter(
        fontSize: FontSizes.headlineSmall,
        fontWeight: FontWeight.bold,
      ),
      titleLarge: GoogleFonts.inter(
        fontSize: FontSizes.titleLarge,
        fontWeight: FontWeight.w500,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: FontSizes.titleMedium,
        fontWeight: FontWeight.w500,
      ),
      titleSmall: GoogleFonts.inter(
        fontSize: FontSizes.titleSmall,
        fontWeight: FontWeight.w500,
      ),
      labelLarge: GoogleFonts.inter(
        fontSize: FontSizes.labelLarge,
        fontWeight: FontWeight.w500,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: FontSizes.labelMedium,
        fontWeight: FontWeight.w500,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: FontSizes.labelSmall,
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: GoogleFonts.inter(
        fontSize: FontSizes.bodyLarge,
        fontWeight: FontWeight.normal,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: FontSizes.bodyMedium,
        fontWeight: FontWeight.normal,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: FontSizes.bodySmall,
        fontWeight: FontWeight.normal,
      ),
    ),
  );

  ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.dark(
      primary: DarkModeColors.darkPrimary,
      onPrimary: DarkModeColors.darkOnPrimary,
      primaryContainer: DarkModeColors.darkPrimaryContainer,
      onPrimaryContainer: DarkModeColors.darkOnPrimaryContainer,
      secondary: DarkModeColors.darkSecondary,
      onSecondary: DarkModeColors.darkOnSecondary,
      tertiary: DarkModeColors.darkTertiary,
      onTertiary: DarkModeColors.darkOnTertiary,
      error: DarkModeColors.darkError,
      onError: DarkModeColors.darkOnError,
      errorContainer: DarkModeColors.darkErrorContainer,
      onErrorContainer: DarkModeColors.darkOnErrorContainer,
      inversePrimary: DarkModeColors.darkInversePrimary,
      shadow: DarkModeColors.darkShadow,
      surface: DarkModeColors.darkSurface,
      onSurface: DarkModeColors.darkOnSurface,
      surfaceContainerHighest: DarkModeColors.darkSurfaceVariant,
      outline: DarkModeColors.darkOutline,
    ),
    brightness: Brightness.dark,
    scaffoldBackgroundColor: DarkModeColors.darkSurface,
    cardColor: DarkModeColors.darkCardBackground,
    appBarTheme: const AppBarTheme(
      backgroundColor: DarkModeColors.darkAppBarBackground,
      foregroundColor: DarkModeColors.darkOnSurface,
      elevation: 0,
      centerTitle: false,
    ),
    cardTheme: CardThemeData(
      color: DarkModeColors.darkCardBackground,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: DarkModeColors.darkPrimary,
        foregroundColor: DarkModeColors.darkOnPrimary,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: DarkModeColors.darkPrimary,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        side: const BorderSide(color: DarkModeColors.darkOutline),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: DarkModeColors.darkSurfaceVariant,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: DarkModeColors.darkPrimary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: DarkModeColors.darkError),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: DarkModeColors.darkSurfaceVariant,
      selectedColor: DarkModeColors.darkPrimaryContainer,
      labelStyle: GoogleFonts.inter(fontSize: 14),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: DarkModeColors.darkSurface,
      selectedItemColor: DarkModeColors.darkPrimary,
      unselectedItemColor: DarkModeColors.darkSecondary,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
      selectedLabelStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
      unselectedLabelStyle: GoogleFonts.inter(fontSize: 12),
    ),
    textTheme: TextTheme(
      displayLarge: GoogleFonts.inter(
        fontSize: FontSizes.displayLarge,
        fontWeight: FontWeight.normal,
      ),
      displayMedium: GoogleFonts.inter(
        fontSize: FontSizes.displayMedium,
        fontWeight: FontWeight.normal,
      ),
      displaySmall: GoogleFonts.inter(
        fontSize: FontSizes.displaySmall,
        fontWeight: FontWeight.w600,
      ),
      headlineLarge: GoogleFonts.inter(
        fontSize: FontSizes.headlineLarge,
        fontWeight: FontWeight.normal,
      ),
      headlineMedium: GoogleFonts.inter(
        fontSize: FontSizes.headlineMedium,
        fontWeight: FontWeight.w500,
      ),
      headlineSmall: GoogleFonts.inter(
        fontSize: FontSizes.headlineSmall,
        fontWeight: FontWeight.bold,
      ),
      titleLarge: GoogleFonts.inter(
        fontSize: FontSizes.titleLarge,
        fontWeight: FontWeight.w500,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: FontSizes.titleMedium,
        fontWeight: FontWeight.w500,
      ),
      titleSmall: GoogleFonts.inter(
        fontSize: FontSizes.titleSmall,
        fontWeight: FontWeight.w500,
      ),
      labelLarge: GoogleFonts.inter(
        fontSize: FontSizes.labelLarge,
        fontWeight: FontWeight.w500,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: FontSizes.labelMedium,
        fontWeight: FontWeight.w500,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: FontSizes.labelSmall,
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: GoogleFonts.inter(
        fontSize: FontSizes.bodyLarge,
        fontWeight: FontWeight.normal,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: FontSizes.bodyMedium,
        fontWeight: FontWeight.normal,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: FontSizes.bodySmall,
        fontWeight: FontWeight.normal,
      ),
    ),
  );
