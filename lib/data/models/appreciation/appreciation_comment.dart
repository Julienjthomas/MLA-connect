import 'package:freezed_annotation/freezed_annotation.dart';

part 'appreciation_comment.freezed.dart';
part 'appreciation_comment.g.dart';

@freezed
abstract class AppreciationComment with _$AppreciationComment {
  const factory AppreciationComment({
    required String id,
    required String citizenId,
    required String body,
    required DateTime createdAt,
  }) = _AppreciationComment;

  factory AppreciationComment.fromJson(Map<String, dynamic> json) =>
      _$AppreciationCommentFromJson(json);
}
