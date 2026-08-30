import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/auth_landing_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/home/presentation/pages/for_you_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';

import '../widgets/coming_soon_page.dart';
import 'app_routes.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const ForYouPage(),
      ),
      GoRoute(
        path: AppRoutes.calendar,
        builder: (context, state) => const ComingSoonPage(title: 'Calendar', tabIndex: 1),
      ),
      GoRoute(
        path: AppRoutes.clips,
        builder: (context, state) => const ComingSoonPage(title: 'Clips', tabIndex: 2),
      ),
      GoRoute(
        path: AppRoutes.store,
        builder: (context, state) => const ComingSoonPage(title: 'Store', tabIndex: 3),
      ),
      GoRoute(
        path: AppRoutes.profile,
        builder: (context, state) => const ComingSoonPage(title: 'Profile', tabIndex: 4),
      ),
      GoRoute(
        path: AppRoutes.welcome,
        builder: (context, state) => const AuthLandingPage(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginPage(),
      ),
    ],
  );
});
