import 'package:dart_project_four/presentation/menu/menu_screen.dart';
import 'package:dart_project_four/presentation/menu/theme_selection_screen.dart';

///* The main application entry point.
///* It runs a loop that manages the current menu screen state.
void main() async {
  
  //note 1. Set the starting screen
  MenuScreen? currentScreen = ThemeSelectionScreen();
  
  //note 2. Run the screen loop
  while (currentScreen != null) {

    //* Display the current screen and wait for it to
    //note return the *next* screen.
    currentScreen = await currentScreen.display();
  }
  
  //* 3. Loop exits when currentScreen is null (e.g., from MainMenuScreen)
  //* The application terminates.
}