import 'package:dart_project_four/presentation/menu/main_menu_screen.dart';
import 'package:dart_project_four/presentation/menu/menu_screen.dart';
import 'package:dart_project_four/presentation/theme/app_theme.dart';
import 'package:dart_project_four/presentation/theme/console_logger.dart';

/// * A [MenuScreen] state that allows the user to change the global [AppTheme].
/// * After setting the theme, it always transitions back to the [MainMenuScreen].
class ChangeThemeScreen implements MenuScreen {

  // note: Get the singleton logger instance
  final ConsoleLogger logger = ConsoleLogger();

// * Clears the screen, displays theme options, and handles user input.
  @override
  Future<MenuScreen?> display() async {
    logger.clear();
    logger.info('🎨 Change Application Theme 🎨');
    logger.text('1. Dark Theme (Recommended)');
    logger.text('2. Light Theme');
    logger.text('0. Back to Main Menu');
    logger.prompt('\nEnter your choice: ');

    String choice = logger.readLineSync();
    switch (choice) {
      case '1':

      // note: Set the static theme instance to Dark
        AppTheme.setTheme(ThemeMode.dark);
        logger.success('Dark Theme activated!');
        break;
      case '2':

      // note: Set the static theme instance to Light
        AppTheme.setTheme(ThemeMode.light);
        logger.success('Light Theme activated!');
        break;
      case '0':
        logger.info('Returning to main menu...');
        break;
      default:
        logger.warning('Invalid choice. No changes made.');
    }

    //* Pause briefly to show the success/warning message
      await Future.delayed(Duration(milliseconds: 1500));
    
    /// * Always transition back to the [MainMenuScreen].
    /// * This completes this state's lifecycle.
    return MainMenuScreen();
  }
}