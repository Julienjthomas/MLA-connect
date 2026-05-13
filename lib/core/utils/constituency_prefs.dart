import 'package:shared_preferences/shared_preferences.dart';

class ConstituencyPrefs {
  ConstituencyPrefs._();

  static const _idKey = 'constituency_id';
  static const _nameKey = 'constituency_name';

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

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_idKey);
    await prefs.remove(_nameKey);
  }
}
