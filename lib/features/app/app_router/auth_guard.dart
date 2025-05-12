import 'package:auto_route/auto_route.dart';

import '../app_logger/ui/app_logger.dart';
// import 'app_router.gr.dart';
import 'auth_service.dart';

class AuthGuard extends AutoRouteGuard {
  final AuthService authService;

  AuthGuard(this.authService);

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    log('AuthGuard: Checking authentication status');
    if (authService.isUserAuthenticated()) {
      log('AuthGuard: User is authenticated');
      resolver.next(); // Allow navigation
    } else {
      logInfo('AuthGuard: User is not authenticated');
      // router.push(LoginRoute()); // Redirect to login page
    }
  }
}
