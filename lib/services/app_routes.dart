abstract final class AppRoutes {
  static const String splash = '/splash';
  static const String home = '/';
  static const String calendar = '/calendar';
  static const String store = '/store';
  static const String feeds = '/feeds';
  static const String createPost = '/create-post';
  static const String savedPosts = '/saved-posts';
  static const String profile = '/profile';
  static const String explore = '/explore';
  static const String userProfilePattern = '/users/:handle';
  static const String userFollowersPattern = '/users/:handle/followers';
  static const String userFollowingPattern = '/users/:handle/following';

  static String userProfile(String handle) =>
      '/users/${Uri.encodeComponent(handle)}';
  static String userFollowers(String handle) =>
      '${userProfile(handle)}/followers';
  static String userFollowing(String handle) =>
      '${userProfile(handle)}/following';
  static const String welcome = '/welcome';
  static const String login = '/login';
  static const String signup = '/signup';

  static const List<String> bottomNavTabs = [home, calendar, feeds, profile];
}
