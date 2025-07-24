import 'package:get_it/get_it.dart';

import '../features/app/app_router/app_router.dart';
import '../features/app/app_router/auth_service.dart';
import '../features/app/app_settings/data/app_settings_data_source.dart';
import '../features/app/app_settings/data/app_settings_data_source_shared_prefs_impl.dart';
import '../features/app/app_settings/data/app_settings_repository_impl.dart';
import '../features/app/app_settings/domain/app_settings_repository.dart';

/// Sets up dependencies related to app settings.
///
/// This function registers the [AppSettingsDataSource] and [AppSettingsRepository]
/// with GetIt. It initializes SharedPreferences and registers
/// [SharedPrefsDataSource] as a lazy singleton. Then, it registers
/// [AppSettingsRepositoryImpl] as a lazy singleton, depending on
/// [AppSettingsDataSource].
Future<void> setupAppSettingDependencies(GetIt getIt) async {
  // Initialize SharedPreferencesWithCache
  final sharedPrefs = await SharedPrefsDataSource.createPrefs();

  getIt.registerLazySingleton<AppSettingsDataSource>(
    () => SharedPrefsDataSource(sharedPrefs),
  );
}

/// Sets up dependencies related to logging.
///
/// This function registers the [AppLogger] with GetIt, using [LoggerImpl].
Future<void> setupLoggerDependencies(GetIt getIt) async {
  getIt.registerLazySingleton<AppLogger>(() => LoggerImpl());
}

/// Sets up all the dependencies for the application.
///
/// This function calls the other setup functions to register dependencies
/// for logging, app settings, and location-related features.
Future<void> setupDependencies(GetIt getIt) async {
  await setupLoggerDependencies(getIt);
  await setupAppSettingDependencies(getIt);
  // Register other dependencies here
  getIt.registerSingleton<AuthService>(AuthService());
  getIt.registerSingleton<AppRouter>(
    AppRouter(getIt<AuthService>()),
    signalsReady: true,
  );
}
