import 'package:shared_preferences/shared_preferences.dart';

class ConstituencyPrefs {
  ConstituencyPrefs._();

  static const _idKey = 'constituency_id';
  static const _nameKey = 'constituency_name';
  static const _localBodyIdKey = 'local_body_id';
  static const _localBodyNameKey = 'local_body_name';
  static const _wardIdKey = 'ward_id';
  static const _wardNameKey = 'ward_name';
  static const _pendingReturnRouteKey = 'pending_return_route';

  static Future<void> save({required String id, required String name}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_idKey, id);
    await prefs.setString(_nameKey, name);
  }

  static Future<String?> getId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_idKey);
  }

  static Future<String?> getName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_nameKey);
  }

  static Future<void> saveLocalBody({required String id, required String name}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localBodyIdKey, id);
    await prefs.setString(_localBodyNameKey, name);
  }

  static Future<String?> getLocalBodyId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_localBodyIdKey);
  }

  static Future<void> saveWard({required String id, required String name}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_wardIdKey, id);
    await prefs.setString(_wardNameKey, name);
  }

  static Future<String?> getWardId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_wardIdKey);
  }

  static Future<String?> getWardName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_wardNameKey);
  }

  static Future<String?> getLocalBodyName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_localBodyNameKey);
  }

  static Future<void> savePendingReturnRoute(String route) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_pendingReturnRouteKey, route);
  }

  static Future<String?> getPendingReturnRoute() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_pendingReturnRouteKey);
  }

  static Future<void> clearPendingReturnRoute() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_pendingReturnRouteKey);
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_idKey);
    await prefs.remove(_nameKey);
    await prefs.remove(_localBodyIdKey);
    await prefs.remove(_localBodyNameKey);
    await prefs.remove(_wardIdKey);
    await prefs.remove(_wardNameKey);
    await prefs.remove(_pendingReturnRouteKey);
  }
}
