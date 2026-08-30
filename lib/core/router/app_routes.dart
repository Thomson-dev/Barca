/// Centralized route path constants. Add one per top-level destination as
/// features are built out.
abstract final class AppRoutes {
  static const String splash = '/splash';
  static const String home = '/';
  static const String calendar = '/calendar';
  static const String clips = '/clips';
  static const String store = '/store';
  static const String profile = '/profile';
  static const String welcome = '/welcome';
  static const String login = '/login';
  static const String signup = '/signup';

  /// Route for each bottom-nav tab index, in the order [AppBottomNavBar]
  /// renders its destinations.
  static const List<String> bottomNavTabs = [home, calendar, clips, store, profile];
}
