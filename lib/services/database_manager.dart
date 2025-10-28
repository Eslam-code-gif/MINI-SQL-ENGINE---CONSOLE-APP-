import 'dart:io';
import 'package:dart_project_four/const/strings.dart';
import 'package:dart_project_four/presentation/theme/console_logger.dart';

/// * Manages database-level operations (creation, deletion).
/// * This service interacts directly with the file system directories.
class DatabaseManager {
  final logger = ConsoleLogger();

  /// * Ensures the root 'databases' directory exists upon initialization.
  DatabaseManager() {
    Directory(basePath).createSync(recursive: true);
  }

/// * Creates a new database (directory) with the given [name].
  void createDatabase(String name) {
    final dir = Directory('$basePath/$name');
    if (dir.existsSync()) {
      throw Exception('Database "$name" already exists.');
    } else {
      dir.createSync();
      logger.success('Database "$name" created successfully.');
    }
  }

/// * Deletes a database (directory) and all its contents recursively.
  /// * Also checks if the deleted DB was the active one and resets it.
  void deleteDatabase(String name) {
    final dir = Directory('$basePath/$name');
    if (!dir.existsSync()) {
      throw Exception('Database "$name" does not exist.');
    }

    try {
      dir.deleteSync(recursive: true);
      
      // note: If the deleted database is the currently active one, reset it.
      if (UseDatabase.currentDatabase == name) {
        UseDatabase.currentDatabase = null;
        logger.warning('Current database "$name" has been deleted. No database selected.');
      } else {
        logger.success('Database "$name" deleted successfully.');
      }
    } catch (e) {
      throw Exception('Failed to delete database "$name": $e');
    }
  }
  
}

/// * A class that manages the *currently selected* database state.
/// * The constructor acts as the 'USE' command logic.
class UseDatabase {
  /// * The global, static reference to the currently active database name.
  static String? currentDatabase;
  final logger = ConsoleLogger();

/// * Sets the [currentDatabase] to [name] if the corresponding directory exists.
  UseDatabase(String name) {
    // note: This uses the global 'basePath' constant from strings.dart
    final dir = Directory('$basePath/$name');
    if (dir.existsSync()) {
      currentDatabase = name;
      logger.success('Now using database "$name".');
    } else {
      throw Exception('Database "$name" does not exist.');
    }
  }
}