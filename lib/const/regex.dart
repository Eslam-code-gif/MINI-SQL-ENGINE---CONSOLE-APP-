// --- Regex for PARSING (extracting parts) ---
// Used by SqlCommand getters to extract specific parts of a valid command.

final insertTableNameRegex = RegExp(r'^INSERT\s+INTO\s+(\w+)\s+VALUES', caseSensitive: false);
final regexExtractTableSelect = RegExp(r'FROM\s+(\w+)$', caseSensitive: false);
final regexExtractColsSelect = RegExp(r'^SELECT\s+([\w\s,]+)\s+FROM\s+\w+$', caseSensitive: false);
final regexExtractCreateDatabaseName = RegExp(r'^CREATE\s+DATABASE\s+(\w+)$', caseSensitive: false);
final regexExtractUseDatabaseName = RegExp(r'^USE\s+(\w+)$', caseSensitive: false);
final regexExtractCreateTableName = RegExp(r'^CREATE\s+TABLE\s+(\w+)\s*\(', caseSensitive: false);

// --- Regex for VALIDATION (checking command structure) ---
// Used by CheckValidCode to determine the command type.

final regexForInsert = RegExp(r'^INSERT\s+INTO\s+\w+\s+VALUES\s*\(\s*([^\s,)]+(\s*,\s*[^\s,)]+)*)?\s*\)$', caseSensitive: false);
final regexSelectAll = RegExp(r'^SELECT\s+\*\s+FROM\s+\w+$', caseSensitive: false);
final regexSelectCols = RegExp(r'^SELECT\s+\w+(\s*,\s*\w+)*\s+FROM\s+\w+$', caseSensitive: false);
final regexCreateDatabase = RegExp(r'^CREATE\s+DATABASE\s+\w+$', caseSensitive: false);
final regexCreateTable = RegExp(r'^CREATE\s+TABLE\s+\w+\s*\(.+\)$', caseSensitive: false);
final regexUseDatabase = RegExp(r'^USE\s+\w+$', caseSensitive: false);

// --- UPDATE Regex ---

final regexUpdateValidation = RegExp(
    r"^UPDATE\s+\w+\s+SET\s+.+\s+WHERE\s+\w+\s*=\s*'[^']+'$",
    caseSensitive: false);

final regexExtractUpdateTable =
    RegExp(r'^UPDATE\s+(\w+)\s+SET', caseSensitive: false);
final regexExtractUpdateSetClause =
    RegExp(r'SET\s+(.+)\s+WHERE', caseSensitive: false);
final regexExtractUpdateWhereClause =
    RegExp(r"WHERE\s+(\w+)\s*=\s*'([^']+)'$", caseSensitive: false);

// --- DELETE Regex ---

final regexDeleteFromWhereValidation = RegExp(
    r"^DELETE\s+FROM\s+\w+\s+WHERE\s+\w+\s*=\s*'[^']+'$",
    caseSensitive: false);
final regexDeleteTableValidation =
    RegExp(r'^DELETE\s+TABLE\s+\w+$', caseSensitive: false);
final regexDeleteDatabaseValidation =
    RegExp(r'^DELETE\s+DATABASE\s+\w+$', caseSensitive: false);

final regexExtractDeleteFromTable =
    RegExp(r'^DELETE\s+FROM\s+(\w+)\s+WHERE', caseSensitive: false);
final regexExtractDeleteWhere =
    RegExp(r"WHERE\s+(\w+)\s*=\s*'([^']+)'$", caseSensitive: false);
final regexExtractDeleteTable =
    RegExp(r'^DELETE\s+TABLE\s+(\w+)$', caseSensitive: false);
final regexExtractDeleteDatabase =
    RegExp(r'^DELETE\s+DATABASE\s+(\w+)$', caseSensitive: false);