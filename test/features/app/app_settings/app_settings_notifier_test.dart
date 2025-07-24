import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:material_palette/features/app/app_logger/domain/abstract_app_logger.dart';
import 'package:material_palette/features/app/app_settings/domain/app_settings_model.dart';
import 'package:material_palette/features/app/app_settings/ui/app_settings_notifier.dart';
import 'package:material_palette/features/app/app_settings/domain/app_settings_repository.dart';
import 'package:material_palette/features/app/app_settings/data/app_settings_repository_impl.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

class MockAppSettingsRepository extends Mock implements AppSettingsRepository {}
class MockAppLogger extends Mock implements AppLogger {}

void main() {
  group('AppSettingsNotifier Tests', () {
    late MockAppSettingsRepository mockRepository;
    late ProviderContainer container;

    setUp(() {
      mockRepository = MockAppSettingsRepository();
      GetIt.I.registerLazySingleton<AppLogger>(() => MockAppLogger());
      container = ProviderContainer(
        overrides: [
          appSettingsRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
    });

    tearDown(() {
      container.dispose();
      GetIt.I.reset();
    });

    test('should preserve old state on update failure', () async {
      // Arrange
      final initialSettings = AppSettings.defaultAppSettings;
      final newSettings = initialSettings.copyWith(isDarkModeEnabled: true);
      when(() => mockRepository.getSettings()).thenAnswer((_) async => Right(initialSettings));
      when(() => mockRepository.updateSettings(newSettings)).thenAnswer((_) async => Left('Update failed'));

      // Act
      await container.read(appSettingsNotifierProvider.notifier).updateSettings(newSettings);

      // Assert
      final state = container.read(appSettingsNotifierProvider);
      expect(state, equals(AsyncData(initialSettings)));
    });
  });
}
