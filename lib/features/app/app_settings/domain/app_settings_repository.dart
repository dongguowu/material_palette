import 'package:fpdart/fpdart.dart';

import 'app_settings_model.dart';

abstract class AppSettingsRepository {
  Future<Either<String, AppSettings>> getSettings();
  Future<Either<String, AppSettings>> updateSettings(
      AppSettings toUpdateSettings);
}
