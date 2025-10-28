import 'dart:io';
import 'package:dart_project_four/const/strings.dart';
import 'package:dart_project_four/services/database_manager.dart';
import 'package:dart_project_four/presentation/theme/console_logger.dart';

/// * A service responsible for reading data from a table file.
/// * It's instantiated with the full path to the table file it needs to read.
class TableReader {
  // * The full, direct path to the table file (e.g., 'databases/db1/users.txt').
  final String tablePath;
  final logger = ConsoleLogger();

  /// * Creates a reader for a specific table file.
  TableReader(this.tablePath);

  /// * Reads and prints the entire content of the table file (SELECT *).
  void readAll() {
    // note: Guard clause: A database must be selected first.
    if (UseDatabase.currentDatabase == null) {
      throw Exception('No database selected. Use a database first.');
    }
    final file = File(tablePath);
    if (!file.existsSync()) throw Exception('Table "$tablePath" not found!');

    final lines = file.readAsLinesSync();
    if (lines.isEmpty) throw Exception('Table is empty.');

    // note: Print header and all data rows.
    logger.tableHeader(lines.first);
    for (int i = 1; i < lines.length; i++) {
      logger.tableRow(lines[i]);
    }
  }

  /// * Reads and prints only specific [selectedColumns] from the table file.
  void readColumns(List<String> selectedColumns) {
    // note: Guard clause: A database must be selected first.
    if (UseDatabase.currentDatabase == null) {
      throw Exception('No database selected. Use a database first.');
    }
    
    final file = File(tablePath);
    if (!file.existsSync()) throw Exception('Table "$tablePath" not found!');

    final lines = file.readAsLinesSync();
    if (lines.isEmpty) throw Exception('Table is empty.');

    // TIT: Column Index Mapping
    // note: Get all available column names from the header.
    List<String> allColumns = lines.first.split(columnDelimiter);
    List<int> selectedIndexes = [];

    // note: Find the index (e.g., 0, 1, 2) for each requested column name.
    for (var col in selectedColumns) {
      int index = allColumns.indexOf(col.trim());
      if (index == -1) {
        throw Exception("Column '$col' not found!");
      }
      selectedIndexes.add(index);
    }

    // TIT: Row Data Extraction
    // note: Print the selected column headers.
    logger.tableHeader(selectedColumns.join(columnDelimiter));

    // note: Iterate data rows (skip header)
    for (int i = 1; i < lines.length; i++) {
      List<String> row = lines[i].split(columnDelimiter);
      // note: Build a new list containing only the values from the selected indexes.
      List<String> selectedValues = [
        for (var index in selectedIndexes)
          (index < row.length ? row[index] : 'NULL') // Handle missing data
      ];
      logger.tableRow(selectedValues.join(columnDelimiter));
    }
  }
}