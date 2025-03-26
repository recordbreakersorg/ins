import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData makeTheme() {
  return ThemeData(
    colorScheme: ColorScheme(
      // Base Colors
      primary: Colors.purple,
      primaryContainer: Colors.purple[700]!,
      onPrimary: Colors.white,
      onPrimaryContainer: Colors.purple[50]!,

      // Secondary Colors
      secondary: Colors.lightBlue,
      secondaryContainer: Colors.lightBlue[700]!,
      onSecondary: Colors.white,
      onSecondaryContainer: Colors.lightBlue[50]!,

      // Tertiary Colors
      tertiary: Colors.red,
      tertiaryContainer: Colors.red[700]!,
      onTertiary: Colors.white,
      onTertiaryContainer: Colors.red[50]!,

      // Error Colors
      error: Colors.red[700]!,
      errorContainer: Colors.red[800]!,
      onError: Colors.white,
      onErrorContainer: Colors.red[50]!,
      surface: Colors.white,
      onSurface: Colors.grey[900]!,
      surfaceContainerHighest: Colors.grey[100]!,
      onSurfaceVariant: Colors.grey[700]!,
      outline: Colors.grey[400]!,
      outlineVariant: Colors.grey[300]!,

      // Additional Surface Colors
      surfaceTint: Colors.purple[200]!,
      inverseSurface: Colors.grey[900]!,
      onInverseSurface: Colors.white,
      inversePrimary: Colors.purple[200]!,

      // Shadow
      shadow: Colors.black,
      scrim: Colors.black54,

      // Brightness
      brightness: Brightness.light,
    ),

    // Define the default `TextTheme`. Use this to specify the default
    // text styling for headlines, titles, bodies of text, and more.
    textTheme: TextTheme(
      displayLarge: const TextStyle(fontSize: 72, fontWeight: FontWeight.bold),
      titleLarge: GoogleFonts.lato(fontSize: 30),
      bodyMedium: GoogleFonts.merriweather(),
      displaySmall: GoogleFonts.pacifico(),
    ),
  );
}
