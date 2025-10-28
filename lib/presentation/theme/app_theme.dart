

/// Defines ANSI escape codes for coloring console output.
class AnsiColors {
  static const String reset = '\x1B[0m';
  static const String bold = '\x1B[1m';
  
  // Regular Colors
  static const String black = '\x1B[30m';
  static const String red = '\x1B[31m';
  static const String green = '\x1B[32m';
  static const String yellow = '\x1B[33m';
  static const String blue = '\x1B[34m';
  static const String magenta = '\x1B[35m';
  static const String cyan = '\x1B[36m';
  
  // Bright/Light Colors (what most terminals render as "light")
  static const String lightGray = '\x1B[90m'; // (Bright Black)
  static const String lightRed = '\x1B[91m';
  static const String lightGreen = '\x1B[92m';
  static const String lightYellow = '\x1B[93m';
  static const String lightBlue = '\x1B[94m';
  static const String lightMagenta = '\x1B[95m';
  static const String lightCyan = '\x1B[96m';
  static const String white = '\x1B[97m';
}

enum ThemeMode { light, dark }

/// Abstract palette defines the *semantic* colors.
abstract class ColorPalette {
  String get text;     // Regular text
  String get success;  // Success messages
  String get error;    // Error messages
  String get info;     // Informational messages
  String get warning;  // Warnings
  String get prompt;   // The 'sql>' prompt
  String get header;   // Table headers
}

/// Light Theme 
class LightThemePalette implements ColorPalette {
  @override
  String get text => AnsiColors.white;
  @override
  String get success => AnsiColors.lightGreen;
  @override
  String get error => AnsiColors.lightRed;
  @override
  String get info => AnsiColors.lightCyan;
  @override
  String get warning => AnsiColors.lightYellow;
  @override
  String get prompt => AnsiColors.bold + AnsiColors.lightGreen;
  @override
  String get header => AnsiColors.bold + AnsiColors.lightYellow;
}

/// Dark Theme (uses darker colors for text)(default)
class DarkThemePalette implements ColorPalette {
  @override
  String get text => AnsiColors.black;
  @override
  String get success => AnsiColors.green; // Darker green
  @override
  String get error => AnsiColors.red;   // Darker red
  @override
  String get info => AnsiColors.blue;
  @override
  String get warning => AnsiColors.magenta;
  @override
  String get prompt => AnsiColors.bold + AnsiColors.blue;
  @override
  String get header => AnsiColors.bold + AnsiColors.magenta;
}

/// Static class to hold the current theme state.
class AppTheme {
  static ColorPalette palette = DarkThemePalette(); // Default

  static void setTheme(ThemeMode mode) {
    if (mode == ThemeMode.dark) {
      palette = DarkThemePalette();
    } else {
      palette = LightThemePalette();
    }
  }
}