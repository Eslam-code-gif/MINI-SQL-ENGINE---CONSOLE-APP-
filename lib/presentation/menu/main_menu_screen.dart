import 'package:dart_project_four/core/engine.dart';
import 'package:dart_project_four/presentation/menu/change_theme_screen.dart';
import 'package:dart_project_four/presentation/menu/menu_screen.dart';
import 'package:dart_project_four/presentation/theme/console_logger.dart';

class MainMenuScreen implements MenuScreen {
  final ConsoleLogger logger = ConsoleLogger();

  @override
  Future<MenuScreen?> display() async {
    logger.welcome();
    logger.text('Please choose an option:');
    logger.text('1. 🚀 Start SQL Engine Session');
    logger.text('2. 🎨 Change Theme');
    logger.text('0. 🚪 Exit Application');
    logger.prompt('\nEnter your choice: ');

    String choice = logger.readLineSync();

    switch (choice) {
      case '1':
        // Transition to the SQL Session "screen"
        return SqlSessionScreen();
      case '2':
        // Transition to the Change Theme "screen"
        return ChangeThemeScreen();
      case '0':
        logger.info('👋 Goodbye! Exiting application...');
        await Future.delayed(Duration(milliseconds: 2500));
        logger.clear();
        return null; // Returning null signals the app to exit
      default:
        logger.error('Invalid choice, please try again.');
        await Future.delayed(Duration(seconds: 2));
        return this; // Return 'this' to re-display the same screen
    }
  }
}


/// This class acts as a "screen" that wraps the existing SqlEngine.
/// Its job is to start the engine and then, when the engine stops,
/// transition back to the main menu.
class SqlSessionScreen implements MenuScreen {
  final ConsoleLogger logger = ConsoleLogger();
  
  @override
  Future<MenuScreen?> display() async {
    logger.clear();
    logger.info('🚀 SQL Engine Session Started.');
    
    SqlEngine engine = SqlEngine();
    // This method blocks until the user types 'EXIT'
    engine.startSession(); 
    
    // After startSession() finishes (user typed 'EXIT')
    logger.info('SQL Session closed. Returning to main menu...');
    await Future.delayed(Duration(seconds: 2));
    
    // Transition back to the Main Menu
    return MainMenuScreen();
  }
}