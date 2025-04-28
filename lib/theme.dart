import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

const Color primaryColor = Color(0xFFE65100); // #E65100

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
    setTheme(_themeMode);
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
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      // Primary colors
      primary: Color(0xFFC66900), // Deep orange
      onPrimary: Colors.white,
      primaryContainer: Color(0xFFFFD9B3),
      onPrimaryContainer: Color(0xFF3A2600),

      // Secondary colors
      secondary: Color(0xFF4F9A94), // Muted teal
      onSecondary: Colors.white,
      secondaryContainer: Color(0xFFB2DFDB),
      onSecondaryContainer: Color(0xFF0A1F1D), // 90% black
      surface: Color(0xFFFFF8F2), // Elevated surfaces
      onSurface: Color(0xFF1F1B16),

      // Error colors
      error: Color(0xFFBA1A1A),
      onError: Colors.white,

      // Neutral colors
      surfaceContainerHighest: Color(0xFFF3E9E1), // For cards/dialogs
      outline: Color(0xFF857369), // Borders/dividers
    ),
    textTheme: TextTheme(
      displayLarge: GoogleFonts.robotoFlex(
        fontSize: 32,
        fontWeight: FontWeight.w800,
        color: Color(0xFF7A4A00), // Warm accent
      ),
      headlineMedium: GoogleFonts.robotoFlex(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.25,
        color: Color(0xFF4F3420),
      ),
      titleLarge: GoogleFonts.robotoFlex(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Color(0xFF4F3420),
      ),
      bodyMedium: GoogleFonts.merriweather(
        fontSize: 16,
        height: 1.6,
        color: Color(0xFF5C4D42), // Warm gray
      ),
      labelLarge: GoogleFonts.robotoFlex(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        color: Color(0xFF6B5C52),
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFFFFF8F2),
      elevation: 1,
      shadowColor: Colors.black.withOpacity(0.1),
      titleTextStyle: GoogleFonts.robotoFlex(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Color(0xFF7A4A00),
      ),
      iconTheme: IconThemeData(color: Color(0xFF7A4A00)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFFC66900),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    cardTheme: CardTheme(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Color(0xFFEDE0D4)),
      ),
    ),
    dividerTheme: DividerThemeData(color: Color(0xFFEDE0D4), space: 24),
    pageTransitionsTheme: PageTransitionsTheme(
      builders: {
        TargetPlatform.android: ZoomPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
  );
  // Dark Theme Configuration
  static final ThemeData _darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      // Primary colors
      primary: Color(0xFFFF9E40), // Softer orange
      onPrimary: Colors.black,
      primaryContainer: Color(0xFFB26F20), // Darker orange container
      onPrimaryContainer: Color(0xFFFFD9B3),

      // Secondary colors
      secondary: Color(0xFF80CBC4), // Soothing teal
      onSecondary: Colors.black,
      secondaryContainer: Color(0xFF4A635F),
      onSecondaryContainer: Color(0xFFB2DFDB), // 87% white
      surface: Color(0xFF1E1E1E), // Elevated surfaces
      onSurface: Color(0xFFE0E0E0),

      // Error colors
      error: Color(0xFFCF6679),
      onError: Colors.black,

      // Neutral colors
      surfaceContainerHighest: Color(0xFF2D2D2D), // For cards/dialogs
      outline: Color(0xFF404040), // Borders/dividers
    ),
    textTheme: TextTheme(
      displayLarge: GoogleFonts.robotoFlex(
        fontSize: 32,
        fontWeight: FontWeight.w800,
        color: Color(0xFFFFB77A), // Warm highlight
      ),
      headlineMedium: GoogleFonts.robotoFlex(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.25,
      ),
      titleLarge: GoogleFonts.robotoFlex(
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      bodyMedium: GoogleFonts.merriweather(
        fontSize: 16,
        height: 1.6,
        color: Color(0xFFCCCCCC), // Soft gray for body
      ),
      labelLarge: GoogleFonts.robotoFlex(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFF1E1E1E),
      elevation: 1,
      shadowColor: Colors.black.withOpacity(0.3),
      titleTextStyle: GoogleFonts.robotoFlex(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Color(0xFFFFB77A),
      ),
      iconTheme: IconThemeData(color: Color(0xFFFFB77A)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFFB26F20),
        foregroundColor: Color(0xFFFFD9B3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    cardTheme: CardTheme(
      color: Color(0xFF2D2D2D),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Color(0xFF404040)),
      ),
    ),
    dividerTheme: DividerThemeData(
      color: Color(0xFF404040).withOpacity(0.5),
      space: 24,
    ),
    pageTransitionsTheme: PageTransitionsTheme(
      builders: {
        TargetPlatform.android: ZoomPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
  );
}

final themeManager = ThemeManager();

class ThemeSwitcherWidget extends StatefulWidget {
  const ThemeSwitcherWidget({super.key});

  @override
  State<ThemeSwitcherWidget> createState() => _ThemeSwitcherWidgetState();
}

class _ThemeSwitcherWidgetState extends State<ThemeSwitcherWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleTheme() {
    final themeManager = ThemeManager();
    final isDark = themeManager.isDarkMode;

    if (isDark) {
      _controller.reverse();
    } else {
      _controller.forward();
    }

    themeManager.setTheme(isDark ? ThemeMode.light : ThemeMode.dark);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeManager(),
      builder: (context, _) {
        final isDark = ThemeManager().isDarkMode;
        return GestureDetector(
          onTap: _toggleTheme,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            width: 80,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: isDark ? Colors.grey[800] : Colors.blueGrey[200],
            ),
            child: Stack(
              children: [
                AnimatedAlign(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOutBack,
                  alignment:
                      isDark ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.all(4),
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDark ? Colors.grey[200] : Colors.amber,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child:
                          isDark
                              ? const Icon(Icons.nightlight_round, size: 20)
                              : const Icon(Icons.wb_sunny, size: 20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
