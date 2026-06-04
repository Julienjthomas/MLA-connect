import 'package:freezed_annotation/freezed_annotation.dart';

part 'public_event_response.freezed.dart';
part 'public_event_response.g.dart';

@freezed
abstract class PublicEventResponse with _$PublicEventResponse {
  const factory PublicEventResponse({
    required String id,
    required String title,
    String? description,
    @Default('event') String kind,
    required DateTime startsAt,
    DateTime? endsAt,
    String? venueName,
    String? venueAddress,
    String? coverImageUrl,
    required DateTime createdAt,
  }) = _PublicEventResponse;

  factory PublicEventResponse.fromJson(Map<String, dynamic> json) =>
      _$PublicEventResponseFromJson(json);
}
