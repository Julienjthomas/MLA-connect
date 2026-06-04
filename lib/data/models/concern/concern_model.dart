import 'package:freezed_annotation/freezed_annotation.dart';

part 'concern_model.freezed.dart';
part 'concern_model.g.dart';

@freezed
abstract class ConcernModel with _$ConcernModel {
  const factory ConcernModel({
    required String id,
    required String citizenId,
    @Default('general') String category,
    required String title,
    required String description,
    String? location,
    String? landmark,
    String? voiceNoteUrl,
    String? wardId,
    String? wardName,
    String? contactNumber,
    @Default('submitted') String status,
    required DateTime createdAt,
    @Default([]) List<String> mediaUrls,
    @Default([]) List<ConcernTimeline> timeline,
  }) = _ConcernModel;

  factory ConcernModel.fromJson(Map<String, dynamic> json) =>
      _$ConcernModelFromJson(json);
}

@freezed
abstract class ConcernTimeline with _$ConcernTimeline {
  const factory ConcernTimeline({
    required String status,
    String? notes,
    required DateTime createdAt,
  }) = _ConcernTimeline;

  factory ConcernTimeline.fromJson(Map<String, dynamic> json) =>
      _$ConcernTimelineFromJson(json);
}
