import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Top-level folders in the `submission-objects` bucket (not DB `submissions.kind` names).
enum SubmissionObjectsFolder {
  problems,
  ideas,
  improvements,
  appreciations,
}

class StorageService {
  SupabaseStorageClient get _storage => Supabase.instance.client.storage;

  static const _mediaBucket = 'media';
  static const _submissionObjectsBucket = 'submission-objects';

  /// Uploads submission images to `submission-objects/{problems|ideas|…}/{userId}/…`.
  ///
  /// [userId] should be the auth user id (`UserModel.id` / `auth.users.id`).
  Future<List<String>> uploadSubmissionFiles(
    List<XFile> files, {
    required SubmissionObjectsFolder folder,
    required String userId,
  }) async {
    final uid = userId.trim();
    if (uid.isEmpty) {
      throw StateError('uploadSubmissionFiles: userId is required');
    }
    final prefix = '${folder.name}/$uid';
    final urls = <String>[];
    for (final file in files) {
      final bytes = await file.readAsBytes();
      final safeName = file.name.replaceAll(RegExp(r'[/\\]'), '_');
      final ext = safeName.contains('.') ? safeName.split('.').last.toLowerCase() : 'jpg';
      final path = '$prefix/${DateTime.now().millisecondsSinceEpoch}_$safeName';
      final contentType = _imageContentType(ext);
      await _storage.from(_submissionObjectsBucket).uploadBinary(
            path,
            bytes,
            fileOptions: FileOptions(contentType: contentType),
          );
      urls.add(path);
    }
    return urls;
  }

  Future<String> uploadVoiceFile(
    String filePath, {
    required SubmissionObjectsFolder folder,
    required String userId,
  }) async {
    final uid = userId.trim();
    if (uid.isEmpty) {
      throw StateError('uploadVoiceFile: userId is required');
    }
    final file = File(filePath);
    final bytes = await file.readAsBytes();
    final path = '${folder.name}/$uid/voice_${DateTime.now().millisecondsSinceEpoch}.m4a';
    await _storage.from(_submissionObjectsBucket).uploadBinary(
          path,
          bytes,
          fileOptions: const FileOptions(contentType: 'audio/mp4'),
        );
    return path;
  }

  static String _imageContentType(String ext) {
    switch (ext) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'webp':
        return 'image/webp';
      case 'heic':
      case 'heif':
        return 'image/heic';
      default:
        return 'image/jpeg';
    }
  }

  Future<String> uploadAvatar(File file, String userId) async {
    final ext = file.path.split('.').last;
    final path = 'avatars/$userId.$ext';
    final bytes = await file.readAsBytes();
    await _storage.from(_mediaBucket).uploadBinary(path, bytes, fileOptions: FileOptions(contentType: 'image/$ext', upsert: true));
    return _storage.from(_mediaBucket).getPublicUrl(path);
  }
}
