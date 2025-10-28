import 'dart:io';
import 'package:dart_project_four/const/strings.dart';
import 'package:dart_project_four/presentation/theme/console_logger.dart';
import 'package:dart_project_four/services/database_manager.dart';

/// * Manages table-level operations (creation, deletion).
/// * This service interacts directly with table files (e.g., 'users.txt').
class TableManager {
  final logger = ConsoleLogger();
  
  /// * Creates a new table file (e.g., 'users.txt').
  /// * The first line of the file will be the column headers.
  void createTable(String tableName, List<String> columns) {
    if (UseDatabase.currentDatabase == null) {
      throw Exception('No database selected. Use a database first.');
    }
    final file = File('$basePath/${UseDatabase.currentDatabase}/$tableName$tableFileExtension');
    if (file.existsSync()) {
      throw Exception('Table "$tableName" already exists.');
    }

    // note: Write the header row (e.g., "id|name|age")
    file.writeAsStringSync(columns.join(columnDelimiter));
    logger.success('Table "$tableName" created with columns: ${columns.join(', ')}');
  }

  /// * Deletes a table file entirely.
  void deleteTable(String tableName) {
    if (UseDatabase.currentDatabase == null) {
      throw Exception('No database selected. Use a database first.');
    }
    
    final tablePath = '$basePath/${UseDatabase.currentDatabase}/$tableName$tableFileExtension';
    final file = File(tablePath);

    if (!file.existsSync()) {
      throw Exception('Table "$tableName" not found!');
    }

    try {
      // note: Deletes the file from the filesystem.
      file.deleteSync();
      logger.success('Table "$tableName" deleted successfully.');
    } catch (e) {
      throw Exception('Failed to delete table "$tableName": $e');
    }
  }
  
}