import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'
    show AsyncValueX, ConsumerWidget, ProviderScope, WidgetRef;
import 'package:get_it/get_it.dart';

import '../features/app/app_router/app_router.dart';
import '../features/app/app_router/auth_service.dart';
import '../features/app/app_themes/ui/app_material_theme.dart';
import '../features/app/app_themes/ui/dark_mode_notifier.dart';
import '../features/app/app_color/app_color_seed_notifier.dart';
import 'setup_dependencies.dart';

final getIt = GetIt.instance;
Future<void> main() async {
  String? loadError;

  WidgetsFlutterBinding.ensureInitialized();

  await setupDependencies(getIt);

  // 1. Load environment variables from .env file
  // try {
  //   await dotenv.load(fileName: ".env");
  // } catch (e) {
  //   loadError = ".env file not found or error loading: $e";
  // }

  // 2. Initialize UserSettingsProvider (SharedPreferences)

  // 3. Initialize DarkModeChangeNotifierProvider (depends on UserSettingsProvider)

  // make sure you register it as a Singleton or a lazySingleton
  getIt.registerSingleton<AuthService>(AuthService());
  getIt.registerSingleton<AppRouter>(
    AppRouter(getIt<AuthService>()),
    signalsReady: true,
  );

  // 4. Setup providers using MultiProvider
  runApp(
    ProviderScope(
      child: MyApp(initialError: loadError), // 4.1 Pass any initial errors
    ),
  );
}

class MyApp extends ConsumerWidget {
  final String? initialError;

  MyApp({super.key, this.initialError});

  final AppRouter _appRouter = getIt<AppRouter>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(darkModeNotifierProvider);
    final seedColor = ref.watch(colorSeedNotifierProvider);

    return MaterialApp.router(
      title: 'Your App',
      theme: ThemeData(
        useMaterial3: true, // Enable Material 3
        colorScheme: ColorScheme.fromSeed(
          seedColor: seedColor, // Use the dynamic seed color from the provider
          brightness: Brightness.light, // Light or dark mode
        ),
      ),
      darkTheme: AppMaterialTheme.dark,
      themeMode:
          themeMode.valueOrNull?.themeMode ??
          ThemeMode.system, // Use the watched ThemeMode
      // routerDelegate: getIt<AppRouter>().delegate(),
      // routeInformationParser: getIt<AppRouter>().defaultRouteParser(),
      routerConfig: _appRouter.config(),
    );
  }
}
