import 'package:app/src/models/theme/flex_color_theme.dart';
import 'package:flutter/material.dart';

class BlockThemes {
  BlockThemes({
    required this.light,
    required this.dark,
    required this.themeMode,
  });

  ThemeData light;
  ThemeData dark;
  ThemeMode themeMode;

  factory BlockThemes.fromJson(Map<String, dynamic> json) {
    return BlockThemes(
      light: flexThemeFromJson(json['flexLight'], 'light'),
      dark: flexThemeFromJson(json['flexDark'], 'dark'),
      themeMode: json['themeMode'] == 'ThemeMode.dark' ? ThemeMode.dark : json['themeMode'] == 'ThemeMode.light' ? ThemeMode.light : ThemeMode.system,
    );
  }
}