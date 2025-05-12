import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../app_logger/ui/app_logger.dart';
import '../app_settings/domain/app_settings_model.dart';
import '../app_settings/ui/app_settings_notifier.dart';

part 'active_tab_notifier.g.dart';

@riverpod
class ActiveTabIndex extends _$ActiveTabIndex {
  @override
  Future<int> build() async {
    try {
      final settings = await fetchCurrentSettings();
      log(
        '[ActiveTabIndex Notifier] Selected tab index: ${settings.selectedPageIndex}',
      );
      return settings.selectedPageIndex ?? 0;
    } catch (e, stackTrace) {
      logError('Error fetching selected tab: $e', e as Error, stackTrace);
      return 0; // Default to 0 if fetching fails
    }
  }

  Future<void> updateActiveTabIndex(int newIndex) async {
    state = await AsyncValue.guard(() async {
      final settings = await fetchCurrentSettings();
      final newSettings = settings.copyWith(selectedPageIndex: newIndex);

      final notifier = ref.read(appSettingsNotifierProvider.notifier);
      await notifier.updateSettings(newSettings);

      log('[ActiveTabIndex] updated to index: $newIndex');
      final updated = await fetchCurrentSettings();
      log(
        '[ActiveTabIndex] updated selected pageIndex: ${updated.selectedPageIndex}',
      );
      state = AsyncValue.data(newIndex);
      return newIndex;
    });
  }

  Future<AppSettings> fetchCurrentSettings() async {
    try {
      final settings = await ref.watch(appSettingsNotifierProvider.future);
      return settings;
    } catch (e, stackTrace) {
      logError('Error fetching selected tab: $e', e as Error, stackTrace);
      return AppSettings
          .defaultAppSettings; // Return default settings in case of failure
    }
  }
}
