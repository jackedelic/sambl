/// Status flags of the application
enum AppStatusFlags {
  /// State of the application when no user has been signed in
  unauthenticated,
  /// State of the application when a user is signed in but has neither started nor joined an order
  authenticated,
  /// State of the application when a user is currently ordering food
  ordering,
  /// State of the application when a user is currently delivering food
  delivering
}