import 'package:freezed_annotation/freezed_annotation.dart';

part 'concern_comment.freezed.dart';
part 'concern_comment.g.dart';

@freezed
abstract class ConcernComment with _$ConcernComment {
  const factory ConcernComment({
    required String id,
    required String citizenId,
    required String body,
    required DateTime createdAt,
  }) = _ConcernComment;

  factory ConcernComment.fromJson(Map<String, dynamic> json) =>
      _$ConcernCommentFromJson(json);
}
