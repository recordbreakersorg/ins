import 'package:flutter/material.dart';

const harbourHaze = [
  Color(0xFF909EAE), // #909EAE -- sage
  Color(0xFF5C8DC5), // #5C8DC5 -- blue
  Color(0xFFAD9E90), // #AD9E90 -- bright gray-brown
  Color(0xFF736F60), // #736F60 -- brown
];

Map<String, ThemeData> themes = {
  'harbourHaze': ThemeData(
    brightness: Brightness.light,
    splashColor: harbourHaze[0],
    primaryColor: harbourHaze[1],
    colorScheme: ColorScheme.light(
      primary: harbourHaze[1],
      secondary: harbourHaze[0],
      surface: harbourHaze[2],
      onSurface: harbourHaze[3],
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: harbourHaze[2]),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: harbourHaze[1]),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: harbourHaze[2]),
      ),
    ),
    textTheme: TextTheme(),
    useMaterial3: true,
    highlightColor: harbourHaze[1],
    focusColor: harbourHaze[0],
  ),
};
