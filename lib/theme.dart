import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

Color lighten(Color color, [double amount = .1]) {
  assert(amount >= 0 && amount <= 1);
  final hsl = HSLColor.fromColor(color);
  final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));
  return hslLight.toColor();
}

Color darken(Color color, [double amount = .1]) {
  assert(amount >= 0 && amount <= 1);
  final hsl = HSLColor.fromColor(color);
  final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
  return hslDark.toColor();
}

const List<Color> harbourHazePalette = [
  Color(
    0xFF909EAE, // #909EAE
  ), // sage (Cool Grayish Blue/Green) - Good for secondary, backgrounds, muted accents
  Color(
    0xFF5C8DC5, // #5C8DC5
  ), // blue (Moderate, slightly desaturated Blue) - Good for primary
  Color(
    0xFFAD9E90, // #AD9E90
  ), // brightGrayBrown (Light, warm Gray/Beige) - Good for surfaces, containers
  Color(
    0xFF736F60, // #736F60
  ), // brown (Muted, earthy Brown) - Good for text, outlines, darker accents
];
final Color hhSage = harbourHazePalette[0];
final Color hhBlue = harbourHazePalette[1];
final Color hhBrightGrayBrown = harbourHazePalette[2];
final Color hhBrown = harbourHazePalette[3];

ThemeData _buildHarbourHazeTheme() {
  // Define base colors from the palette for Material 3 ColorScheme
  final Color primaryColor = hhBlue;
  final Color secondaryColor = hhSage;
  final Color surfaceColor = lighten(
    hhBrightGrayBrown,
    0.35,
  ); // Lighter for main surfaces
  final Color errorColor = const Color(0xFFB00020); // Standard error red

  // Define "on" colors (colors for text/icons on top of the base colors)
  final Color onPrimaryColor = Colors.black; // For text on primaryColor
  final Color onSecondaryColor = darken(
    hhBrown,
    0.9,
  ); // Darker brown for text on secondaryColor
  final Color onSurfaceColor = darken(
    hhBrown,
    0.5,
  ); // Main text color on surfaceColor
  final Color onErrorColor = Colors.white;

  // Create the ColorScheme
  final ColorScheme colorScheme = ColorScheme(
    brightness: Brightness.light,

    primary: primaryColor,
    onPrimary: onPrimaryColor,
    primaryContainer: lighten(primaryColor, 0.5),
    onPrimaryContainer: darken(
      primaryColor,
      0.3,
    ), // Or hhBrown if contrast is better

    secondary: secondaryColor,
    onSecondary: onSecondaryColor,
    secondaryContainer: lighten(secondaryColor, 0.25),
    onSecondaryContainer: darken(secondaryColor, 0.3), // Or hhBrown

    tertiary: hhBrightGrayBrown, // Using this as a tertiary accent
    onTertiary: hhBrown,
    tertiaryContainer: lighten(hhBrightGrayBrown, 0.1),
    onTertiaryContainer: darken(hhBrown, 0.05),

    error: errorColor,
    onError: onErrorColor,
    errorContainer: lighten(errorColor, 0.4),
    onErrorContainer: darken(errorColor, 0.2),

    surface: surfaceColor, // Main surfaces like cards, dialogs
    onSurface: onSurfaceColor, // Text on surface

    surfaceContainerHighest: lighten(
      hhBrightGrayBrown,
      0.3,
    ), // For elements like Card backgrounds, chip backgrounds
    onSurfaceVariant: hhBrown, // Text on surfaceVariant

    outline: hhBrown.withAlpha(128),
    outlineVariant: hhSage.withAlpha(180),

    shadow: Colors.black.withAlpha(26),
    scrim: Colors.black.withAlpha(100),

    inverseSurface: darken(onSurfaceColor, 0.1), // For snackbars, etc.
    onInverseSurface: lighten(surfaceColor, 0.1),
    inversePrimary: lighten(primaryColor, 0.2),
    surfaceTint: primaryColor.withAlpha(10), // Tint for elevations
  );

  // Define TextTheme using GoogleFonts and ColorScheme
  final TextTheme originalTextTheme = TextTheme(
    displayLarge: GoogleFonts.robotoFlex(
      fontSize: 32,
      fontWeight: FontWeight.w800,
      color: colorScheme.primary,
    ),
    headlineMedium: GoogleFonts.robotoFlex(
      fontSize: 24,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.25,
      color: colorScheme.onSurface,
    ),
    titleLarge: GoogleFonts.robotoFlex(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: colorScheme.onSurface.withAlpha(110),
    ),
    bodyLarge: GoogleFonts.merriweather(
      // For prominent body text
      fontSize: 18,
      height: 1.5,
      color: colorScheme.onSurface,
    ),
    bodyMedium: GoogleFonts.merriweather(
      // Standard body text
      fontSize: 16,
      height: 1.6,
      color: colorScheme.onSurface,
    ),
    labelLarge: GoogleFonts.robotoFlex(
      // For buttons
      fontSize: 14,
      fontWeight: FontWeight.w600, // Buttons often have bolder labels
      letterSpacing: 0.2,
      color: colorScheme.onPrimary,
    ), // Assuming buttons use primary color
    titleMedium: GoogleFonts.robotoFlex(
      // For list tiles, smaller titles
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: colorScheme.onSurfaceVariant,
    ),
    bodySmall: GoogleFonts.merriweather(
      // Captions, smaller text
      fontSize: 12,
      height: 1.4,
      color: colorScheme.onSurface.withOpacity(0.7),
    ),
  );
  return ThemeData(
    brightness: Brightness.light,
    colorScheme: colorScheme,
    primaryColor: primaryColor, // Still useful for some older widgets
    scaffoldBackgroundColor: colorScheme.surface,

    splashColor: colorScheme.primary.withAlpha(30),
    highlightColor: colorScheme.primary.withAlpha(26),
    focusColor: colorScheme.secondary.withAlpha(30),

    appBarTheme: AppBarTheme(
      backgroundColor: colorScheme.surface, // Or surfaceContainerHighest
      foregroundColor: colorScheme.onSurfaceVariant, // For title and icons
      elevation: 1,
      shadowColor: colorScheme.shadow,
      titleTextStyle: originalTextTheme.titleLarge?.copyWith(
        color: colorScheme.primary,
      ),
      iconTheme: IconThemeData(color: colorScheme.secondary), // Or primary
    ),

    textTheme: originalTextTheme,

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: colorScheme.surfaceContainerHighest.withAlpha(128),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 12.0,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: colorScheme.outline, width: 1.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(
          color: colorScheme.outline.withAlpha(175),
          width: 1.0,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: colorScheme.primary, width: 2.0),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: colorScheme.error, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: colorScheme.error, width: 2.0),
      ),
      labelStyle: originalTextTheme.bodyMedium?.copyWith(
        color: colorScheme.onSurfaceVariant,
      ),
      hintStyle: originalTextTheme.bodyMedium?.copyWith(
        color: colorScheme.onSurfaceVariant.withOpacity(0.7),
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        textStyle: originalTextTheme.labelLarge, // Already has onPrimary color
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 2,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: colorScheme.primary,
        textStyle: originalTextTheme.labelLarge?.copyWith(
          color: colorScheme.primary,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: colorScheme.primary,
        side: BorderSide(color: colorScheme.primary, width: 1.5),
        textStyle: originalTextTheme.labelLarge?.copyWith(
          color: colorScheme.primary,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),

    cardTheme: CardThemeData(
      color: colorScheme
          .surfaceContainerHighest, // Slightly different from main surface for visual separation
      elevation: 0.5, // Subtle elevation
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: colorScheme.outlineVariant.withAlpha(128),
          width: 1,
        ),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
    ),

    dividerTheme: DividerThemeData(
      color: colorScheme.outlineVariant.withAlpha(150),
      thickness: 1,
      space: 24,
    ),

    chipTheme: ChipThemeData(
      backgroundColor: colorScheme.secondaryContainer.withAlpha(175),
      labelStyle: originalTextTheme.bodySmall?.copyWith(
        color: colorScheme.onSecondaryContainer,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      side: BorderSide.none,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    ),

    dialogTheme: DialogThemeData(
      backgroundColor: colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      titleTextStyle: originalTextTheme.headlineMedium?.copyWith(
        color: colorScheme.onSurface,
      ),
      contentTextStyle: originalTextTheme.bodyMedium?.copyWith(
        color: colorScheme.onSurface.withAlpha(200),
      ),
    ),

    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: colorScheme.secondary, // Or primary or tertiary
      foregroundColor: colorScheme.onSecondary,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),

    listTileTheme: ListTileThemeData(
      iconColor: colorScheme.secondary,
      titleTextStyle: originalTextTheme.titleMedium,
      subtitleTextStyle: originalTextTheme.bodySmall?.copyWith(
        color: colorScheme.onSurfaceVariant.withAlpha(200),
      ),
    ),

    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: colorScheme.surface, // or surfaceContainer
      selectedItemColor: colorScheme.primary,
      unselectedItemColor: colorScheme.onSurfaceVariant.withOpacity(0.7),
      selectedLabelStyle: originalTextTheme.bodySmall?.copyWith(
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: originalTextTheme.bodySmall,
      elevation: 2,
    ),

    tabBarTheme: TabBarThemeData(
      labelColor: colorScheme.primary,
      unselectedLabelColor: colorScheme.onSurfaceVariant.withOpacity(0.8),
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(color: colorScheme.primary, width: 2.0),
      ),
      labelStyle: originalTextTheme.labelLarge?.copyWith(
        color: colorScheme.primary,
        fontWeight: FontWeight.w600,
      ), // color set by labelColor
      unselectedLabelStyle: originalTextTheme.labelLarge?.copyWith(
        color: colorScheme.onSurfaceVariant,
        fontWeight: FontWeight.w500,
      ), // color set by unselectedLabelColor
    ),

    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: OpenUpwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(), // Good practice
        TargetPlatform.linux: OpenUpwardsPageTransitionsBuilder(),
        TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
      },
    ),
    useMaterial3: true,
  );
}

// Your themes map
final Map<String, ThemeData> themes = {
  'harbourHaze': _buildHarbourHazeTheme(),
  // You can add more themes here if needed
};
const themeKey = "app_theme";

class ThemeManager with ChangeNotifier {
  static final ThemeManager _instance = ThemeManager._internal();
  factory ThemeManager() => _instance;
  ThemeManager._internal();

  String theme = "harbourHaze";

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final themename = prefs.getString(themeKey) ?? 'harbourHaze';
    setTheme(themename);
    notifyListeners();
  }

  ThemeData getTheme() {
    return themes[theme]!;
  }

  Future<void> setTheme(String themename) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(themeKey, themename);
    notifyListeners();
  }
}

final themeManager = ThemeManager();
