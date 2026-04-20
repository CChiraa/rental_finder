import 'package:flutter/material.dart';

const lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFFB8964F), // gold accent
  onPrimary: Colors.white,
  secondary: Color(0xFFEAD8BE), // soft beige
  onSecondary: Colors.black,
  error: Colors.red,
  onError: Colors.white,
  surface: Color(0xFFF8F1E7), // warm beige surface
  onSurface: Color(0xFF2C2621),
);

const darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFFD6B36A), // gold accent
  onPrimary: Colors.black,
  secondary: Color(0xFF2A241E), // deep warm secondary
  onSecondary: Colors.white,
  error: Colors.redAccent,
  onError: Colors.white,
  surface: Color(0xFF1E1E1E), // dark grey surface
  onSurface: Colors.white,
);

ThemeData lightMode = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  colorScheme: lightColorScheme,
  scaffoldBackgroundColor: const Color(0xFFF8F1E7),
  cardColor: Colors.white,

  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFFF8F1E7),
    foregroundColor: Color(0xFF2C2621),
    elevation: 0,
    centerTitle: true,
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(
        lightColorScheme.primary,
      ),
      foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
      elevation: MaterialStateProperty.all<double>(5),
      padding: MaterialStateProperty.all<EdgeInsets>(
        const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      ),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
    ),
  ),

  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: Color(0xFFB8964F), width: 1.5),
    ),
    hintStyle: const TextStyle(color: Color(0xFF8B7355)),
  ),

  switchTheme: SwitchThemeData(
    thumbColor: MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.selected)) {
        return const Color(0xFFB8964F);
      }
      return Colors.grey.shade400;
    }),
    trackColor: MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.selected)) {
        return const Color(0xFFE1C27A);
      }
      return Colors.grey.shade300;
    }),
  ),

  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
    selectedItemColor: Color(0xFFB8964F),
    unselectedItemColor: Colors.grey,
    type: BottomNavigationBarType.fixed,
  ),

  listTileTheme: const ListTileThemeData(
    iconColor: Color(0xFFB8964F),
    textColor: Color(0xFF2C2621),
  ),

  cardTheme: CardThemeData(
    color: Colors.white,
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  ),

  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Color(0xFF2C2621)),
    bodyMedium: TextStyle(color: Color(0xFF7B664C)),
    titleLarge: TextStyle(
      color: Color(0xFF2C2621),
      fontWeight: FontWeight.bold,
    ),
    titleMedium: TextStyle(
      color: Color(0xFF2C2621),
      fontWeight: FontWeight.w600,
    ),
  ),
);

ThemeData darkMode = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: darkColorScheme,
  scaffoldBackgroundColor: const Color(0xFF121212), // main background
  cardColor: const Color(0xFF1E1E1E), // cards

  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF121212),
    foregroundColor: Colors.white,
    elevation: 0,
    centerTitle: true,
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(
        const Color(0xFFD6B36A),
      ),
      foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
      elevation: MaterialStateProperty.all<double>(6),
      padding: MaterialStateProperty.all<EdgeInsets>(
        const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      ),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
    ),
  ),

  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFF1E1E1E),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: Color(0xFFD6B36A), width: 1.5),
    ),
    hintStyle: const TextStyle(color: Color(0xFFB7A999)),
  ),

  switchTheme: SwitchThemeData(
    thumbColor: MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.selected)) {
        return const Color(0xFFD6B36A);
      }
      return Colors.grey.shade500;
    }),
    trackColor: MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.selected)) {
        return const Color(0xFFB8964F);
      }
      return Colors.grey.shade700;
    }),
  ),

  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Color(0xFF1A1A1A),
    selectedItemColor: Color(0xFFD6B36A),
    unselectedItemColor: Colors.grey,
    type: BottomNavigationBarType.fixed,
  ),

  listTileTheme: const ListTileThemeData(
    iconColor: Color(0xFFD6B36A),
    textColor: Colors.white,
  ),

  cardTheme: CardThemeData(
    color: const Color(0xFF1E1E1E),
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  ),

  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.white),
    bodyMedium: TextStyle(color: Color(0xFFD1C7BC)),
    titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    titleMedium: TextStyle(
      color: Color(0xFFF0E6D8),
      fontWeight: FontWeight.w600,
    ),
  ),
);
