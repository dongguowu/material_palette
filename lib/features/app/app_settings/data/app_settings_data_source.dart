import 'package:fpdart/fpdart.dart';

import '../domain/app_settings_model.dart';

abstract class AppSettingsDataSource {
  Future<Either<String, AppSettings>> getSettings();
  Future<Either<String, AppSettings>> updateSettings(AppSettings settings);
}
