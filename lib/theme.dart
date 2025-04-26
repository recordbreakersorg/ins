import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

const Color _primaryColor = Color(0xFFE65100); // #E65100

class ThemeManager with ChangeNotifier {
  static final ThemeManager _instance = ThemeManager._internal();
  factory ThemeManager() => _instance;
  ThemeManager._internal();

  ThemeMode _themeMode = ThemeMode.light;
  ThemeMode get themeMode => _themeMode;
  final String _themeKey = 'app_theme';

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final savedIndex = prefs.getInt(_themeKey) ?? ThemeMode.light.index;
    _themeMode = ThemeMode.values[savedIndex];
    notifyListeners();
  }

  ThemeData get theme => _isDarkMode ? _darkTheme : _lightTheme;
  ThemeData get darkTheme => _darkTheme;
  ThemeData get lightTheme => _lightTheme;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  bool get _isDarkMode => _themeMode == ThemeMode.dark;

  Future<void> setTheme(ThemeMode mode) async {
    _themeMode = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeKey, mode.index);
    notifyListeners();
  }

  // Light Theme Configuration
  static final ThemeData _lightTheme = ThemeData(
    pageTransitionsTheme: PageTransitionsTheme(
      builders: {
        TargetPlatform.android: ZoomPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _primaryColor,
      brightness: Brightness.light,
      primary: _primaryColor,
      secondary: const Color(0xFFF57C00),
    ),
    textTheme: TextTheme(
      displayLarge: GoogleFonts.lato(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      titleLarge: GoogleFonts.lato(fontSize: 24, fontWeight: FontWeight.w600),
      bodyMedium: GoogleFonts.merriweather(fontSize: 16, height: 1.5),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: _primaryColor,
      titleTextStyle: GoogleFonts.lato(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    ),
  );

  // Dark Theme Configuration
  static final ThemeData _darkTheme = ThemeData(
    pageTransitionsTheme: PageTransitionsTheme(
      builders: {
        TargetPlatform.android: ZoomPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _primaryColor,
      brightness: Brightness.dark,
      primary: const Color(0xFFFF6D00),
      secondary: const Color(0xFFFF9800),
    ),
    textTheme: TextTheme(
      displayLarge: GoogleFonts.lato(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      titleLarge: GoogleFonts.lato(fontSize: 24, fontWeight: FontWeight.w600),
      bodyMedium: GoogleFonts.merriweather(fontSize: 16, height: 1.5),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFFFF6D00),
      titleTextStyle: GoogleFonts.lato(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
    ),
  );
}

final themeManager = ThemeManager();
