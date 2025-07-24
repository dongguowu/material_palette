import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../app_logger/ui/app_logger.dart';
import '../data/app_settings_repository_impl.dart';
import '../domain/app_settings_model.dart';
import '../domain/app_settings_repository.dart';

part 'app_settings_notifier.g.dart';

/// Always return a AppSettings
@riverpod
class AppSettingsNotifier extends _$AppSettingsNotifier {
  late final AppSettingsRepository _rep;

  @override
  Future<AppSettings> build() async {
    _rep = ref.read(appSettingsRepositoryProvider);

    final either = await _rep.getSettings();
    return either.match(
      (error) {
        logError('[AppSettingsNotifier] Failed to fetch settings: $error');
        return AppSettings
            .defaultAppSettings; // Return default settings on error
      },
      (settings) {
        logInfo('[AppSettingsNotifier] fetched $settings.toString()');
        return settings;
      },
    );
  }

  // Call update on AppSettingsNotifier and return Either<String, AppSettings>
  // UI can rely on the state updates through Riverpod's reactivity
  // callers can use the returned Either for error handling
  Future<Either<String, AppSettings>> updateSettings(
      AppSettings toUpdatesettings) async {
    final oldState = state.valueOrNull ?? AppSettings.defaultAppSettings;
    state = const AsyncLoading();
    final either = await _rep.updateSettings(toUpdatesettings);
    state = AsyncData(either.match(
      (error) {
        logError('[AppSettingsNotifier] Failed to update settings: $error');
        return oldState;
      },
      (settings) {
        logInfo('[AppSettingsNotifier] Updated settings: $settings.toString()');
        return settings;
      },
    ));
    return either;
  }
}
