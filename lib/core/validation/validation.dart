import 'package:dart_project_four/const/regex.dart';
import 'package:dart_project_four/core/util/sql_command.dart';

/// * Defines the specific type of a SQL command.
/// * This enum is used by the SqlEngine to determine which logic to execute.
enum SqlCommandType {
  selectStar,
  selectCols,
  insert,
  update,
  deleteFromWhere,
  deleteTable,
  deleteDatabase,
  createDatabase,
  createTable,
  use,
  invalid
}

class CheckValidCode{

  /// * Validates a raw command string and returns its [SqlCommandType].
  /// * It cleans the command first, then tests it against a series of Regex patterns.
  /// *
  /// * ? This method determines the "intent" of the command before the parser
  /// * ? tries to extract data from it.
  SqlCommandType getCommandType(String code) {

    // note: Clean the command (trim whitespace, remove ';') before validation.
    final trimmedCode = SqlCommand.cleanCommand(code);

    // note: The order of checks matters, from more specific to more general.
    if (regexSelectAll.hasMatch(trimmedCode)) {
      return SqlCommandType.selectStar;
    } else if (regexSelectCols.hasMatch(trimmedCode)) {
      return SqlCommandType.selectCols;
    } else if (regexForInsert.hasMatch(trimmedCode)) {
      return SqlCommandType.insert;
    } else if (regexCreateDatabase.hasMatch(trimmedCode)) {
      return SqlCommandType.createDatabase;
    } else if (regexCreateTable.hasMatch(trimmedCode)) {
      return SqlCommandType.createTable;
    } else if (regexUseDatabase.hasMatch(trimmedCode)) {
      return SqlCommandType.use;
    } else if (regexUpdateValidation.hasMatch(trimmedCode)) { 
      return SqlCommandType.update;
    }else if (regexDeleteFromWhereValidation.hasMatch(trimmedCode)) {
      return SqlCommandType.deleteFromWhere;
    } 
    else if (regexDeleteTableValidation.hasMatch(trimmedCode)) {
      return SqlCommandType.deleteTable;
    } 
    else if (regexDeleteDatabaseValidation.hasMatch(trimmedCode)) {
      return SqlCommandType.deleteDatabase;
    } else {
      // note: If no regex matches, the command is considered invalid.
      return SqlCommandType.invalid;
    }
  }
  
}

