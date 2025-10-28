import 'dart:io';
import 'package:dart_project_four/const/strings.dart';
import 'package:dart_project_four/services/database_manager.dart';
import 'package:dart_project_four/presentation/theme/console_logger.dart';

/// * A service responsible for handling 'DELETE FROM ... WHERE ...' logic.
class TableDeleter {
  final logger = ConsoleLogger();

  /// * Deletes rows from a table file that match a specific [whereCondition].
  /// *
  /// * This method reads the entire file, filters out matching rows,
  /// * and then rewrites the file with the remaining rows.
  void deleteRows(String tableName, MapEntry<String, String> whereCondition) {
    // note: Guard clause: A database must be selected first.
    if (UseDatabase.currentDatabase == null) {
      throw Exception('No database selected. Use a database first.');
    }

    final tablePath = '$basePath/${UseDatabase.currentDatabase}/$tableName$tableFileExtension';
    final file = File(tablePath);

    if (!file.existsSync()) {
      throw Exception('Table "$tableName" not found!');
    }

    // note: Read all lines to process in memory.
    final lines = file.readAsLinesSync();
    if (lines.isEmpty) {
      throw Exception('Table "$tableName" is empty.');
    }

    // TIT: Column Validation

    final List<String> allColumns = lines.first.split(columnDelimiter);
    final String whereKey = whereCondition.key;
    final String whereValue = whereCondition.value;

    int whereColIndex = allColumns.indexOf(whereKey);
    if (whereColIndex == -1) {
      throw Exception("Column '$whereKey' in WHERE clause not found.");
    }

    // TIT: Row Filtering
    // note: Start the new file content with the header row.

    List<String> newLines = [lines.first];
    int deletedRowCount = 0;

    // note: Iterate from 1 to skip the header row.
    for (int i = 1; i < lines.length; i++) {
      List<String> row = lines[i].split(columnDelimiter);

      // note: Check if the value in the WHERE column matches.
      if (row[whereColIndex] == whereValue) {
        // note: Match found. Increment counter and *do not* add this line to newLines.
        deletedRowCount++;
      } else {
        // note: No match. Keep this line.
        newLines.add(lines[i]);
      }
    }

    // TIT: File Rewrite
    // note: Overwrite the file with the filtered list of lines.
    file.writeAsStringSync(newLines.join('\n'));
    
    logger.success('$deletedRowCount row(s) deleted successfully from "$tableName".');
  }
}