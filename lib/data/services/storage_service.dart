import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StorageService {
  SupabaseStorageClient get _storage => Supabase.instance.client.storage;

  Future<List<String>> uploadFiles(List<XFile> files, String folder) async {
    final urls = <String>[];
    for (final file in files) {
      final bytes = await file.readAsBytes();
      final ext = file.name.split('.').last;
      final path = '$folder/${DateTime.now().millisecondsSinceEpoch}_${file.name}';
      await _storage.from('media').uploadBinary(path, bytes, fileOptions: FileOptions(contentType: 'image/$ext'));
      final url = _storage.from('media').getPublicUrl(path);
      urls.add(url);
    }
    return urls;
  }

  Future<String> uploadAvatar(File file, String userId) async {
    final ext = file.path.split('.').last;
    final path = 'avatars/$userId.$ext';
    final bytes = await file.readAsBytes();
    await _storage.from('media').uploadBinary(path, bytes, fileOptions: FileOptions(contentType: 'image/$ext', upsert: true));
    return _storage.from('media').getPublicUrl(path);
  }
}
