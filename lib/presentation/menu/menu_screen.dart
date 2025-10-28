//* Abstract base class for all menu screens (the "State" in the State Pattern).
//? Each screen is responsible for displaying itself and returning
//* the next screen to transition to.
abstract class MenuScreen {
  //* Displays the screen, handles input, and returns the next screen.
  ///
  /// Returns `null` to signal the application to exit.
  Future<MenuScreen?> display();
}