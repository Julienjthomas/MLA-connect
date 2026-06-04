import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/event/public_event_response.dart';

part 'events_api.g.dart';

@RestApi()
abstract class EventsApi {
  factory EventsApi(Dio dio, {String? baseUrl}) = _EventsApi;

  @GET('/constituencies/{constituencyId}/public-events')
  Future<List<PublicEventResponse>> getEvents(
    @Path('constituencyId') String constituencyId,
  );

  @GET('/constituencies/{constituencyId}/public-events/{eventId}')
  Future<PublicEventResponse> getEvent(
    @Path('constituencyId') String constituencyId,
    @Path('eventId') String eventId,
  );

  @POST('/constituencies/{constituencyId}/public-events/{eventId}/show-interest')
  Future<void> showInterest(
    @Path('constituencyId') String constituencyId,
    @Path('eventId') String eventId,
  );

  @GET('/constituencies/public-events/upcoming')
  Future<List<PublicEventResponse>> getUpcoming();
}
