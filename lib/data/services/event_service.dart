import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../features/auth/controllers/auth_controller.dart';
import '../models/event_model.dart';
import '../remote/events_api.dart';

class EventService {
  EventsApi get _api => Get.find<EventsApi>();

  String? get _constituencyId =>
      Get.isRegistered<AuthController>()
          ? Get.find<AuthController>().user.value?.constituencyId
          : null;

  Future<List<EventModel>> getEvents({int limit = 50, String? constituencyId}) async {
    final cid = constituencyId ?? _constituencyId;
    if (cid == null) return [];
    try {
      final events = await _api.getEvents(cid);
      return events.map(_mapEvent).take(limit).toList();
    } catch (e) {
      debugPrint('[EventService] getEvents error: $e');
      return [];
    }
  }

  Future<EventModel?> getEvent(String id) async {
    final cid = _constituencyId;
    if (cid == null) return null;
    try {
      return _mapEvent(await _api.getEvent(cid, id));
    } catch (e) {
      debugPrint('[EventService] getEvent error: $e');
      return null;
    }
  }

  Future<List<EventModel>> getUpcoming({int limit = 5, String? constituencyId}) async {
    try {
      final events = await _api.getUpcoming();
      return events.map(_mapEvent).take(limit).toList();
    } catch (e) {
      debugPrint('[EventService] getUpcoming error: $e');
      return [];
    }
  }

  EventModel _mapEvent(e) => EventModel(
        id: e.id,
        title: e.title,
        description: e.description,
        kind: e.kind,
        startsAt: e.startsAt,
        endsAt: e.endsAt,
        venueName: e.venueName,
        venueAddress: e.venueAddress,
        coverImageUrl: e.coverImageUrl,
        createdAt: e.createdAt,
      );
}
