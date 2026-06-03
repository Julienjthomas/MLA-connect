import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_config_model.freezed.dart';
part 'app_config_model.g.dart';

/// Example freezed model — matches GET /app-config response.
///
/// Pattern for all future models:
/// 1. Annotate with @freezed
/// 2. Define factory constructor with all fields
/// 3. Add fromJson factory
/// 4. Run: dart run build_runner build
@freezed
abstract class AppConfigModel with _$AppConfigModel {
  const factory AppConfigModel({
    required String appVersion,
    required String minVersion,
    @Default(false) bool maintenanceMode,
    @Default(false) bool forceUpdate,
  }) = _AppConfigModel;

  factory AppConfigModel.fromJson(Map<String, dynamic> json) =>
      _$AppConfigModelFromJson(json);
}
