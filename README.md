
# 🚀 Mini SQL Engine (Dart)

![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)

A lightweight, file-based SQL database engine built from scratch using pure Dart. This project provides a console-based interface (REPL) for executing simplified SQL-like commands to manage databases, tables, and records.

It serves as a practical example of applying core software design principles like **Clean Architecture**, **State Pattern**, and **Singleton Pattern** in a console application.

## ✨ Features

* **Full CRUD & DDL:** Supports `CREATE`, `SELECT`, `INSERT`, `UPDATE`, and `DELETE` commands.
* **File-Based Storage:** Databases are directories, and tables are `.txt` files.
* **Clean Architecture:** Code is separated into `Core`, `Presentation`, and `Services` layers.
* **Interactive REPL:** A "Read-Eval-Print Loop" (REPL) console for typing SQL commands.
* **Theming Support:** Switch between custom **Dark** and **Light** color themes for the console.
* **Robust Parsing:** Uses RegEx for flexible and powerful command validation and parsing.
* **Clear Error Handling:** Provides user-friendly error messages for syntax and logical failures.

## 🛠️ Project Structure

The project uses a Clean Architecture approach to separate concerns, making it modular and easy to maintain.

```

lib/
├── core/
│   ├── engine.dart       \# The main engine (orchestrator)
│   ├── validation/       \# The command validator (CheckValidCode)
│   └── util/             \# The command parser (SqlCommand)
├── presentation/
│   ├── menu/             \# Menu screens (State Pattern)
│   └── theme/            \# AppTheme, AnsiColors, and ConsoleLogger (Singleton)
├── services/
│   ├── database\_manager.dart \# Handles DB (directory) operations
│   ├── table\_manager.dart    \# Handles Table (file) operations
│   ├── table\_reader.dart     \# Handles SELECT
│   ├── table\_writer.dart     \# Handles INSERT
│   ├── table\_updater.dart    \# Handles UPDATE
│   └── table\_deleter.dart    \# Handles DELETE
├── const/
│   ├── regex.dart        \# All RegEx patterns
│   └── strings.dart      \# Global constants (basePath, delimiters)
└── main.dart             \# The application entry point (State Runner)

````

## 🚀 Getting Started

To run the project on your local machine:

1.  **Clone the repository:**
    ```sh
    git clone https://github.com/Eslam-code-gif/MINI-SQL-ENGINE---CONSOLE-APP-.git
    cd MINI-SQL-ENGINE---CONSOLE-APP-
    ```

2.  **Get dependencies :**
    ```sh
    dart pub get
    ```

3.  **Run the application:**
    ```sh
    dart run lib/main.dart
    ```

## 📖 SQL Command Reference

The engine uses a simplified, SQL-like syntax. Commands are **case-insensitive** and support optional trailing semicolons (`;`).

### Database Commands

```sql
-- Create a new database (a new folder)
CREATE DATABASE <db_name>;

-- Switch to a database to perform operations
USE <db_name>;

-- Delete an entire database and all its tables
DELETE DATABASE <db_name>;
````

### Table Commands

```sql
-- Create a new table (a new .txt file) with columns
CREATE TABLE <table_name> (<col1>, <col2>, ...);

-- Delete an entire table and all its data
DELETE TABLE <table_name>;
```

### Data Manipulation Commands

```sql
-- Insert a new row of data
INSERT INTO <table_name> VALUES ('<val1>', '<val2>', ...);

-- Select all columns from a table
SELECT * FROM <table_name>;

-- Select specific columns from a table
SELECT <col1>, <col2> FROM <table_name>;

-- Update rows in a table based on a simple WHERE clause
-- Note: Supports multiple SET clauses, but only a single = 'value' condition.
UPDATE <table_name> SET <col1> = '<new_val>', <col2> = '<new_val>' WHERE <col> = '<val>';

-- Delete rows from a table based on a simple WHERE clause
-- Note: Only supports a single = 'value' condition.
DELETE FROM <table_name> WHERE <col> = '<val>';
```

### Session Command

```sql
-- Exit the SQL session and return to the main menu
EXIT
```

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](https://www.google.com/search?q=LICENSE) file for details.

-----

Copyright (c) 2025 Abdelrahim Mohamed Abdelrahim Ibrahim(Eslam-code-gif)

