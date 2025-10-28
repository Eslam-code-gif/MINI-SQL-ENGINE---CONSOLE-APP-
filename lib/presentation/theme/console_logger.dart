import 'dart:io';
import 'package:dart_project_four/presentation/theme/app_theme.dart';

///* A singleton service for all console output.
///* This ensures all prints are themed and centralized.
class ConsoleLogger {
  // Singleton pattern
  static final ConsoleLogger _instance = ConsoleLogger._internal();
  factory ConsoleLogger() {
    return _instance;
  }
  ConsoleLogger._internal();

  //TIT --- Semantic Outputs ---

  void text(String message) {
    print(AppTheme.palette.text + message + AnsiColors.reset);
  }

  void info(String message) {
    print('${AppTheme.palette.info} ℹ️  $message${AnsiColors.reset}');
  }
  
  void success(String message) {
    print('${AppTheme.palette.success} ✅ $message${AnsiColors.reset}');
  }

  void error(String message) {
    //note Remove "Exception: " prefix if it exists
    final cleanMessage = message.replaceFirst('Exception: ', '');
    print('${AppTheme.palette.error} ❌ Error: $cleanMessage${AnsiColors.reset}');
  }
  
  void warning(String message) {
    print('${AppTheme.palette.warning} ⚠️ Warning: $message${AnsiColors.reset}');
  }

  //TIT --- Special Outputs ---

  void tableHeader(String header) {
    print(AppTheme.palette.header + header + AnsiColors.reset);
  }

  void tableRow(String row) {
    print(AppTheme.palette.text + row + AnsiColors.reset);
  }

  void prompt(String message) {
    stdout.write(AppTheme.palette.prompt + message + AnsiColors.reset);
  }
  
  void clear() {
    if (Platform.isWindows) {
      stdout.write('\x1B[2J\x1B[0;0H');
    } else {
      stdout.write('\x1B[2J\x1B[3J\x1B[H');
    }
  }
  
  void welcome() {
    clear();
    info('======================================');
    info('  Welcome to Mini SQL Engine! 🚀');
    info('======================================');
    text('\n');
  }
  
  //TIT --- Input ---

  String readLineSync() {
    //* Set input color to default text
    stdout.write(AppTheme.palette.text);
    String? input = stdin.readLineSync();
    stdout.write(AnsiColors.reset); // Reset after input
    return input ?? '';
  }
}