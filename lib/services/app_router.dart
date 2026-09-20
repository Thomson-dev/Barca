import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../views/auth_landing_view.dart';
import '../views/calendar_view.dart';
import '../views/create_post_view.dart';
import '../views/feeds_view.dart';
import '../views/for_you_view.dart';
import '../views/login_view.dart';
import '../views/profile_view.dart';
import '../views/social_profile_views.dart';
import '../views/splash_view.dart';
import 'app_routes.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashView(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const ForYouView(),
      ),
      GoRoute(
        path: AppRoutes.calendar,
        builder: (context, state) => const CalendarView(),
      ),
      GoRoute(
        path: AppRoutes.feeds,
        builder: (context, state) => FeedsView(
          initialPostIndex: state.extra is int ? state.extra as int : 0,
        ),
      ),
      GoRoute(
        path: AppRoutes.createPost,
        builder: (context, state) => const CreatePostView(),
      ),
      GoRoute(
        path: AppRoutes.savedPosts,
        builder: (context, state) => const SavedPostsView(),
      ),
      GoRoute(
        path: AppRoutes.profile,
        builder: (context, state) => const ProfileView(),
      ),
      GoRoute(
        path: AppRoutes.explore,
        builder: (context, state) => const ExploreUsersView(),
      ),
      GoRoute(
        path: AppRoutes.userFollowersPattern,
        builder: (context, state) => PeopleListView(
          handle: state.pathParameters['handle']!,
          showFollowers: true,
        ),
      ),
      GoRoute(
        path: AppRoutes.userFollowingPattern,
        builder: (context, state) => PeopleListView(
          handle: state.pathParameters['handle']!,
          showFollowers: false,
        ),
      ),
      GoRoute(
        path: AppRoutes.userProfilePattern,
        builder: (context, state) =>
            OtherProfileView(handle: state.pathParameters['handle']!),
      ),
      GoRoute(
        path: AppRoutes.welcome,
        builder: (context, state) => const AuthLandingView(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginView(),
      ),
    ],
  );
});
