import 'package:auto_route/auto_route.dart';

import 'app_router.gr.dart';
import 'auth_guard.dart';
import 'auth_service.dart';

// Define route paths as constants for better maintainability
const String notFoundPath = '*'; // Fallback for unmatched paths
const String rootPath = '/'; // Root path for the app
const String errorPath = '/error';

@AutoRouterConfig(replaceInRouteName: 'Screen|Page,Route')
class AppRouter extends RootStackRouter {
  late final AuthGuard _authGuard;

  AppRouter(AuthService authService) {
    _authGuard = AuthGuard(authService);
  }

  @override
  List<AutoRoute> get routes => [
    AutoRoute(
      page: RootAdaptiveScreenRoute.page,
      initial: true,
      children: [
        AutoRoute(page: HomeRoute.page, path: 'home'),
        AutoRoute(
          page: SeedColorGeneratorRoute.page,
          path: 'seed-color-generator',
        ),
        AutoRoute(page: ColorHelperRoute.page, path: 'helper'),
        AutoRoute(page: AboutRoute.page, path: 'about'),
      ],
    ),
    // Other routes
    AutoRoute(
      page: NavigationErrorRoute.page,
      path: errorPath,
      guards: [_authGuard],
    ), // Ensure this route is protected
    // Optionally add a fallback route for unmatched paths
    AutoRoute(page: NotFoundRoute.page, path: '*'),
  ];
}
