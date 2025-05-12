import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../app_logger/ui/app_logger.dart';
import '../../app_settings/domain/app_settings_model.dart';
import '../../app_settings/ui/app_settings_notifier.dart';
import '../data/dark_mode_model.dart';

part 'dark_mode_notifier.g.dart';

@riverpod
class DarkModeNotifier extends _$DarkModeNotifier {
  Future<Either<String, AppSettings>> _updateSettings(
      AppSettings settings) async {
    final notifier = ref.read(appSettingsNotifierProvider.notifier);
    return await notifier.updateSettings(settings);
  }

  @override
  Future<DarkModeModel> build() async {
    final asyncIsDark = await ref.watch(appSettingsNotifierProvider
        .selectAsync((item) => item.isDarkModeEnabled));
    log('[DarkModeNotifier] fetched value from AppSettings: ${asyncIsDark.toString()}');
    return _fromBool(asyncIsDark ?? false);
  }

  Future<void> toggleDarkMode() async {
    final currentState = state.valueOrNull;
    final isDark = currentState?.themeMode == ThemeMode.light;
    await updateDarkMode(isDark: isDark);
  }

  Future<void> updateDarkMode({required bool isDark}) async {
    final currentState = state.valueOrNull;
    if (currentState == null) return;

    final currentIsDark = currentState.themeMode == ThemeMode.dark;
    if (currentIsDark == isDark) {
      log('[DarkModeNotifier] Skipped update, same value: $isDark');
      return;
    }

    final updated = AppSettings(isDarkModeEnabled: isDark);
    
    try {
      final either = await _updateSettings(updated);
      
      either.match(
        (error) {
          log('[DarkModeNotifier] Error updating dark mode: $error');
          state = AsyncData(_fromBool(!isDark));
        },
        (settings) {
          log('[DarkModeNotifier] Updated DarkMode to: ${settings.isDarkModeEnabled}');
          state = AsyncData(_fromBool(settings.isDarkModeEnabled ?? isDark));
        },
      );
    } catch (e) {
      log('[DarkModeNotifier] Exception updating dark mode: $e');
      state = AsyncData(_fromBool(!isDark));
    }
  }

  DarkModeModel _fromBool(bool isDark) {
    return DarkModeModel(
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
    );
  }
}

