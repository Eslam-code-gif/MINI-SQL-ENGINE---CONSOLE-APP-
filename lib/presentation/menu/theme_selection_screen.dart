import 'package:dart_project_four/presentation/menu/main_menu_screen.dart';
import 'package:dart_project_four/presentation/menu/menu_screen.dart';
import 'package:dart_project_four/presentation/theme/app_theme.dart';
import 'package:dart_project_four/presentation/theme/console_logger.dart';

class ThemeSelectionScreen implements MenuScreen {
  final ConsoleLogger logger = ConsoleLogger();

  @override
  Future<MenuScreen?> display() async {
    logger.clear();
    logger.info('🎨 Please select your preferred theme:');
    logger.text('1. Dark Theme (Recommended)');
    logger.text('2. Light Theme');
    logger.prompt('\nEnter your choice: ');

    String choice = logger.readLineSync();
    switch (choice) {
      case '1':
        AppTheme.setTheme(ThemeMode.dark);
        logger.success('Dark Theme set.');
        break;
      case '2':
        AppTheme.setTheme(ThemeMode.light);
        logger.success('Light Theme set.');
        break;
      default:
        logger.warning('Invalid choice. Defaulting to Dark Theme.');
        AppTheme.setTheme(ThemeMode.dark);
    }
    
    // Pause briefly to show the message
    await Future.delayed(Duration(milliseconds: 1500));
    
    // Transition to the Main Menu
    return MainMenuScreen();
  }
}