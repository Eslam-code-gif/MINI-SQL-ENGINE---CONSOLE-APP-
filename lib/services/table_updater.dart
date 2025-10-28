import 'dart:io';
import 'package:dart_project_four/const/strings.dart';
import 'package:dart_project_four/services/database_manager.dart';
import 'package:dart_project_four/presentation/theme/console_logger.dart';

/// * A service responsible for handling 'UPDATE ... SET ... WHERE ...' logic.
class TableUpdater {
  final logger = ConsoleLogger();

  /// * Updates rows in a table file that match a [whereCondition]
  /// * with the new values specified in [setValues].
  /// *
  /// * This method reads the entire file, modifies matching rows in memory,
  /// * and then rewrites the entire file.
  void updateRows(String tableName, Map<String, String> setValues,
      MapEntry<String, String> whereCondition) {
    if (UseDatabase.currentDatabase == null) {
      throw Exception('No database selected. Use a database first.');
    }

    final tablePath = '$basePath/${UseDatabase.currentDatabase}/$tableName$tableFileExtension';
    final file = File(tablePath);

    if (!file.existsSync()) {
      throw Exception('Table "$tableName" not found!');
    }

    final lines = file.readAsLinesSync();
    if (lines.isEmpty) {
      throw Exception('Table "$tableName" is empty.');
    }

    // TIT: Column Validation & Index Mapping

    final List<String> allColumns = lines.first.split(columnDelimiter);
    final String whereKey = whereCondition.key;
    final String whereValue = whereCondition.value;

    // note: Find the index of the column used in the WHERE clause.
    int whereColIndex = allColumns.indexOf(whereKey);
    if (whereColIndex == -1) {
      throw Exception("Column '$whereKey' in WHERE clause not found.");
    }

    // note: Create a map of {columnIndex -> newValue} for the SET clause.
    // note: e.g., {1: 'NewName', 2: 'NewCity'}
    Map<int, String> setInstructions = {}; // Map<index, newValue>
    for (var entry in setValues.entries) {
      int colIndex = allColumns.indexOf(entry.key);
      if (colIndex == -1) {
        throw Exception("Column '${entry.key}' in SET clause not found.");
      }
      setInstructions[colIndex] = entry.value;
    }

    // TIT: Row Update Logic
    // note: Start the new file content with the header row.
    List<String> newLines = [lines.first]; 
    int updatedRowCount = 0;

    // note: Iterate data rows (skip header).
    for (int i = 1; i < lines.length; i++) {
      List<String> row = lines[i].split(columnDelimiter);

      // note: Check if the current row matches the WHERE condition.
      if (row[whereColIndex] == whereValue) {
        updatedRowCount++;
        
        // note: This row matches. Apply all updates from setInstructions.
        for (var instruction in setInstructions.entries) {
          int indexToUpdate = instruction.key;
          String newValue = instruction.value;
          row[indexToUpdate] = newValue;
        }
      }
      // note: Add the row (either updated or original) to the new line list.
      newLines.add(row.join(columnDelimiter));
    }

    // TIT: File Rewrite
    // note: Overwrite the file with the modified list of lines.
    file.writeAsStringSync(newLines.join('\n'));
    
    logger.success('$updatedRowCount row(s) updated successfully in "$tableName".');
  }
}