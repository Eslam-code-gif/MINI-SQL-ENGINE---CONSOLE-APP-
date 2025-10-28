import 'package:dart_project_four/const/regex.dart';


/// * This class wraps a raw SQL command string.
/// * It provides a set of getters to easily parse and extract
/// * specific parts of the command (like table names, columns, and values).
/// * It is responsible for all command-parsing logic, keeping the SqlEngine clean.
class SqlCommand {
  // note: The cleaned, raw SQL command string, stored privately.
  final String _command;

  // TIT: Setup & Constructor

  /// * A static helper to clean the raw command input.
  /// * It trims whitespace and removes the optional trailing semicolon (;)
  /// * before the command is processed by the validator or parser.

  static String cleanCommand(String command) {
    String temp = command.trim();
    if (temp.endsWith(';')) {
      temp = temp.substring(0, temp.length - 1);
    }
    return temp;
  }

  /// * Creates a new command object from a raw string.
  /// * The command is immediately cleaned upon creation.
  SqlCommand(String command) : _command = cleanCommand(command);

// TIT: General Purpose Getters

  /// * Gets the database name from a 'USE' or 'CREATE DATABASE' command.
  /// * It tries both Regex patterns.
  String get databaseName {
    var useMatch = regexExtractUseDatabaseName.firstMatch(_command);
    if (useMatch != null) {
      return useMatch.group(1)!;
    }
    
    var createMatch = regexExtractCreateDatabaseName.firstMatch(_command);
    if (createMatch != null) {
      return createMatch.group(1)!;
    }
    
    throw FormatException("Cannot extract database name from command.");
  }
  // * Gets the table name from a 'CREATE TABLE' command.
  String get createTableName {
    final match = regexExtractCreateTableName.firstMatch(_command);
    if (match == null) {
      throw FormatException("Invalid CREATE TABLE syntax for parsing name.");
    }
    return match.group(1)!;
  }
// * Gets the table name from an 'INSERT' command.
  String get insertTableName {
    final match = insertTableNameRegex.firstMatch(_command);
    if (match == null) throw FormatException("Invalid INSERT syntax");
    return match.group(1)!;
  }
  // * Gets the table name from a 'SELECT' command.
  String get selectTableName {
    final match = regexExtractTableSelect.firstMatch(_command);
    if (match == null) throw FormatException("Invalid SELECT syntax");
    return match.group(1)!;
  }

  // TIT: Column & Value Parsers

/// * Gets the list of columns from a 'SELECT' command.
/// * e.g., "SELECT col1, col2 FROM..." -> ["col1", "col2"]
  List<String> get selectColumns {
    final match = regexExtractColsSelect.firstMatch(_command);
    if (match == null) throw FormatException("Invalid SELECT syntax");
    return match.group(1)!.toLowerCase().split(',').map((col) => col.trim()).toList();
  }

  /// * Gets the list of columns from a 'CREATE TABLE' command.
  /// * e.g., "CREATE TABLE users (id, name)" -> ["id", "name"]
  List<String> get createTableColumns {
    String columnsStr = _command.substring(_command.indexOf('(') + 1, _command.lastIndexOf(')'));
    return columnsStr.toLowerCase().split(',').map((col) => col.trim()).toList();
  }

  /// * Gets the list of values from an 'INSERT' command.
  /// * This getter also handles removing surrounding quotes from string literals.
  /// * e.g., "VALUES ('1', 'Ahmed')" -> ["1", "Ahmed"]
  List<String> get insertValues {
    String valuesStr = _command.substring(_command.indexOf('(') + 1, _command.lastIndexOf(')'));
    
    List<String> values = valuesStr.split(',');

    
    return values.map((val) {
      String trimmedVal = val.trim();
      
      // note: Check if the value is a string literal (e.g., 'Ahmed')
      if (trimmedVal.startsWith("'") && trimmedVal.endsWith("'")) {
        // note: Return the value *without* the quotes.
        return trimmedVal.substring(1, trimmedVal.length - 1);
      }
      // note: Return as-is (e.g., a number '1')
      return trimmedVal;
    }).toList();
  }

  // TIT: UPDATE Getters

  // * Gets the table name from an 'UPDATE' command.
  String get updateTableName {
    final match = regexExtractUpdateTable.firstMatch(_command);
    if (match == null) {
      throw FormatException("Invalid UPDATE syntax: Cannot find table name.");
    }
    return match.group(1)!;
  }

/// * Gets the SET clause values from an 'UPDATE' command as a Map.
/// * e.g., "SET col1 = 'val1', col2 = 'val2'" -> {col1: 'val1', col2: 'val2'}
  Map<String, String> get updateSetValues {
    final match = regexExtractUpdateSetClause.firstMatch(_command);
    if (match == null) {
      throw FormatException("Invalid UPDATE syntax: Cannot find SET clause.");
    }

    Map<String, String> setValues = {};
    //note  "col1 = 'val1', col2 = 'val2'"
    String setClause = match.group(1)!;
    
    //note ["col1 = 'val1'", " col2 = 'val2'"]
    List<String> pairs = setClause.split(','); 

    for (var pair in pairs) {
      //note ["col1 ", " 'val1'"]
      List<String> parts = pair.split('=');
      if (parts.length != 2) {
        throw FormatException("Invalid SET syntax in: $pair");
      }
      
      String key = parts[0].trim();
      String value = parts[1].trim();

      // note: Remove quotes from string literals
      if (value.startsWith("'") && value.endsWith("'")) {
        value = value.substring(1, value.length - 1);
      }
      
      setValues[key] = value;
    }
    return setValues;
  }

/// * Gets the WHERE condition from an 'UPDATE' command.
/// * Returns a MapEntry where key = column, value = literal.
  MapEntry<String, String> get updateWhereCondition {
    final match = regexExtractUpdateWhereClause.firstMatch(_command);
    if (match == null) {
      throw FormatException("Invalid UPDATE syntax: Cannot find WHERE clause.");
    }
    return MapEntry(match.group(1)!, match.group(2)!);
  }

// TIT: DELETE Getters

/// * Gets the table name from a 'DELETE' command.
/// * This handles both 'DELETE FROM' and 'DELETE TABLE' syntax.
  String get deleteTableName {

    // note: First, try the 'DELETE FROM ...' syntax
    var match = regexExtractDeleteFromTable.firstMatch(_command);
    if (match != null) {
      return match.group(1)!;
    }
    
    // note: If that fails, try the 'DELETE TABLE ...' syntax
    match = regexExtractDeleteTable.firstMatch(_command);
    if (match != null) {
      return match.group(1)!;
    }

    throw FormatException("Cannot extract table name from DELETE command.");
  }

// * Gets the WHERE condition from a 'DELETE FROM' command.
  MapEntry<String, String> get deleteWhereCondition {
    final match = regexExtractDeleteWhere.firstMatch(_command); 
    if (match == null) {
      throw FormatException("Invalid DELETE syntax: Cannot find WHERE clause.");
    }
    return MapEntry(match.group(1)!, match.group(2)!);
  }

// * Gets the database name from a 'DELETE DATABASE' command.
  String get deleteDatabaseName {
    final match = regexExtractDeleteDatabase.firstMatch(_command);
    if (match == null) {
      throw FormatException("Cannot extract database name from DELETE DATABASE.");
    }
    return match.group(1)!;
  }
}