import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:material_palette/features/app/app_settings/domain/app_settings_repository.dart';
import 'package:material_palette/setup_dependencies.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mocktail/mocktail.dart';

class MockAppSettingsRepository extends Mock implements AppSettingsRepository {}

void main() {
  group('Dependency Injection Tests', () {
    setUpAll(() async {
      TestWidgetsFlutterBinding.ensureInitialized();
      SharedPreferences.setMockInitialValues({});
      await setupDependencies(GetIt.instance);
      GetIt.I.unregister<AppSettingsRepository>();
      GetIt.I.registerLazySingleton<AppSettingsRepository>(() => MockAppSettingsRepository());
    });

    tearDownAll(() {
      GetIt.I.reset();
    });

    test('AppSettingsRepository should be registered correctly', () {
      // Act
      final instance = GetIt.I.get<AppSettingsRepository>();

      // Assert
      expect(instance, isA<AppSettingsRepository>());
      expect(instance, isA<MockAppSettingsRepository>());
    });
  });
}
