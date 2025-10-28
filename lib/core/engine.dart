import 'package:dart_project_four/const/strings.dart';
import 'package:dart_project_four/presentation/theme/console_logger.dart';
import 'package:dart_project_four/services/database_manager.dart';
import 'package:dart_project_four/services/table_manager.dart';
import 'package:dart_project_four/services/table_reader.dart';
import 'package:dart_project_four/services/table_writer.dart';
import 'package:dart_project_four/core/util/sql_command.dart';
import 'package:dart_project_four/core/validation/validation.dart';
import 'package:dart_project_four/services/table_updater.dart';
import 'package:dart_project_four/services/table_deleter.dart';

//TIT The core of the mini-SQL application. This class orchestrates the entire process
//TIT from command validation to execution by delegating tasks to services.

class SqlEngine {
  final logger = ConsoleLogger();
final _validator = CheckValidCode();

  //TIT Starts the interactive SQL session (REPL - Read-Eval-Print Loop).
  //TIT It continuously prompts the user for commands until 'EXIT' is entered.

  void startSession() {
    logger.info("Type your SQL commands. (Type 'EXIT' to return to main menu)");
    
    while (true) {
      String command = getCurrentCommand();


      if (command.trim().toUpperCase() == 'EXIT') {
        logger.warning("Returning to main menu...");
        break;
      }

      processCommand(command);
    }
  }

//TIT Prompts the user with "sql> " and reads their input.

  String getCurrentCommand() {
    logger.prompt("sql> ");
    return logger.readLineSync();
  }
  
  //TIT Processes a single raw SQL command string.
  //TIT This method is the central dispatcher, routing commands to the appropriate service.
  //TIT It also acts as the main error handler for the application logic.
  
  void processCommand(String command) {
    try {
      // 1. Validate the command to get its type (e.g., CREATE, SELECT, etc.)
      SqlCommandType commandType = _validator.getCommandType(command);

      // 2. Parse the command to create an object for easy data extraction.
      SqlCommand sql = SqlCommand(command);

      // 3. Use a switch to dispatch the command to the correct service.
    switch (commandType) {
      case SqlCommandType.selectStar:
        logger.info("Processing SELECT * ...");
        TableReader('$basePath/${UseDatabase.currentDatabase}/${sql.selectTableName }$tableFileExtension')
            .readAll();
        break;
      case SqlCommandType.selectCols:
        logger.info("Processing SELECT (cols) ...");
        TableReader('$basePath/${UseDatabase.currentDatabase}/${sql.selectTableName}$tableFileExtension')
            .readColumns(sql.selectColumns);
        break;
      case SqlCommandType.insert:
        logger.info("Processing INSERT ...");
        TableWriter('$basePath/${UseDatabase.currentDatabase}/${sql.insertTableName}$tableFileExtension')
            .insertRow(sql.insertValues);
        break;
      case SqlCommandType.update:
        logger.info("Processing UPDATE command...");
        String tableName = sql.updateTableName;
          Map<String, String> setValues = sql.updateSetValues;
          MapEntry<String, String> whereCondition = sql.updateWhereCondition;
          
          TableUpdater().updateRows(tableName, setValues, whereCondition);
          break;
      case SqlCommandType.deleteFromWhere:
          logger.info("Processing DELETE FROM...WHERE command...");
          String tableName = sql.deleteTableName;
          MapEntry<String, String> whereCondition = sql.deleteWhereCondition;
          TableDeleter().deleteRows(tableName, whereCondition);
          break;

        case SqlCommandType.deleteTable:
          logger.info("Processing DELETE TABLE command...");
          String tableName = sql.deleteTableName;
          TableManager().deleteTable(tableName);
          break;

        case SqlCommandType.deleteDatabase:
          logger.info("Processing DELETE DATABASE command...");
          String dbName = sql.deleteDatabaseName;
          DatabaseManager().deleteDatabase(dbName);
          break;
      case SqlCommandType.createDatabase:
          logger.info("Processing CREATE DATABASE...");
          DatabaseManager().createDatabase(sql.databaseName);
          break;
        case SqlCommandType.createTable:
          logger.info("Processing CREATE TABLE...");
          String tableNam = sql.createTableName;
          List<String> columns = sql.createTableColumns;
          TableManager().createTable(tableNam, columns);
          break;
        case SqlCommandType.use:
          logger.info("Processing USE...");
          UseDatabase(sql.databaseName);
          break;
        case SqlCommandType.invalid:
          throw Exception("Invalid SQL command.");
    }
  }
  on FormatException catch (e) {
      // Handle errors from the parser (e.g., invalid 'SET' syntax, bad 'WHERE')
      logger.error("Parsing command failed: ${e.message}");
    } on Exception catch (e) {
      // Handle logical errors from services (e.g., "Table not found", "DB exists")
      logger.error(e.toString());
    } catch (e) {
      // Catch any other unexpected, non-logical errors.
      logger.error("An unexpected error occurred: $e");
    }
  }
}