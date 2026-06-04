import 'package:freezed_annotation/freezed_annotation.dart';

part 'idea_comment.freezed.dart';
part 'idea_comment.g.dart';

@freezed
abstract class IdeaComment with _$IdeaComment {
  const factory IdeaComment({
    required String id,
    required String citizenId,
    required String body,
    required DateTime createdAt,
  }) = _IdeaComment;

  factory IdeaComment.fromJson(Map<String, dynamic> json) =>
      _$IdeaCommentFromJson(json);
}
