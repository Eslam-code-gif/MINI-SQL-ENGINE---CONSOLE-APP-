import 'dart:io';
import 'package:dart_project_four/const/strings.dart';
import 'package:dart_project_four/presentation/theme/console_logger.dart';
import 'package:dart_project_four/services/database_manager.dart';

/// * A service responsible for writing new data to a table file (INSERT).
class TableWriter {
  // * The full, direct path to the table file (e.g., 'databases/db1/users.txt').
  final String tablePath;
  final logger = ConsoleLogger(); 

  /// * Creates a writer for a specific table file.
  TableWriter(this.tablePath);

  /// * Appends a new row of [values] to the end of the table file.
  void insertRow(List<String> values) {
    // note: Guard clause: A database must be selected first.
    if (UseDatabase.currentDatabase == null) {
      throw Exception('No database selected. Use a database first.');
    }
    
    final file = File(tablePath);
    if (!file.existsSync()) throw Exception('Table "$tablePath" not found!');
    
    // note: Join the values with the delimiter and append to the file
    // note: with a preceding newline to ensure it's a new row.
    file.writeAsStringSync('\n${values.join(columnDelimiter)}', mode: FileMode.append);
    logger.success('Row inserted successfully.');
  }
}