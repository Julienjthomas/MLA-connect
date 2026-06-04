import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

/// Payload returned after a successful media upload.
class UploadedMedia {
  const UploadedMedia({
    required this.s3Key,
    required this.fileName,
    required this.mediaType,
    required this.displayOrder,
  });
  final String s3Key;
  final String fileName;
  final String mediaType;
  final int displayOrder;

  Map<String, dynamic> toJson() => {
        's3_key': s3Key,
        'file_name': fileName,
        'media_type': mediaType,
        'display_order': displayOrder,
      };
}

/// Handles presigned URL → S3 upload flow for submissions.
///
/// Endpoint paths for presigned URLs are not yet confirmed with the backend.
/// Update [_presignEndpoint] when the backend confirms the paths.
class MediaUploadService {
  Dio get _dio => Get.find<Dio>();

  static String _presignEndpoint(String entityType) {
    // TODO: confirm presigned URL endpoint paths with backend
    return '/citizens/:citizenId/$entityType/media/presigned-url';
  }

  /// Uploads [file] to S3 via presigned URL.
  /// [entityType] is one of: 'concerns', 'ideas', 'appreciations'.
  /// [displayOrder] is the 0-based index of the file in the attachment list.
  Future<UploadedMedia?> uploadFile(File file, String entityType, int displayOrder) async {
    final fileName = file.path.split('/').last;
    final mediaType = _mediaType(fileName);

    try {
      // Step 1: get presigned URL from backend
      final presignResp = await _dio.post(
        _presignEndpoint(entityType),
        data: {'file_name': fileName, 'media_type': mediaType},
      );

      final body = presignResp.data;
      if (body is! Map<String, dynamic>) return null;
      final data = (body['data'] ?? body) as Map<String, dynamic>;
      final uploadUrl = data['upload_url'] as String?;
      final s3Key = data['s3_key'] as String?;
      if (uploadUrl == null || s3Key == null) return null;

      // Step 2: PUT bytes directly to S3
      final bytes = await file.readAsBytes();
      await Dio().put(
        uploadUrl,
        data: Stream.fromIterable([bytes]),
        options: Options(
          headers: {
            'Content-Type': _contentType(fileName),
            'Content-Length': bytes.length,
          },
          sendTimeout: const Duration(minutes: 2),
          receiveTimeout: const Duration(minutes: 2),
        ),
      );

      return UploadedMedia(
        s3Key: s3Key,
        fileName: fileName,
        mediaType: mediaType,
        displayOrder: displayOrder,
      );
    } catch (e) {
      debugPrint('[MediaUploadService] uploadFile error: $e');
      return null;
    }
  }

  /// Uploads multiple files sequentially. Returns null entries for failed uploads.
  Future<List<UploadedMedia?>> uploadFiles(List<File> files, String entityType) async {
    final results = <UploadedMedia?>[];
    for (var i = 0; i < files.length; i++) {
      results.add(await uploadFile(files[i], entityType, i));
    }
    return results;
  }

  String _mediaType(String fileName) {
    final ext = fileName.split('.').last.toLowerCase();
    if (['mp4', 'mov', 'avi'].contains(ext)) return 'video';
    if (['mp3', 'm4a', 'aac'].contains(ext)) return 'audio';
    return 'image';
  }

  String _contentType(String fileName) {
    final ext = fileName.split('.').last.toLowerCase();
    return switch (ext) {
      'jpg' || 'jpeg' => 'image/jpeg',
      'png' => 'image/png',
      'gif' => 'image/gif',
      'mp4' => 'video/mp4',
      'mov' => 'video/quicktime',
      'mp3' => 'audio/mpeg',
      'm4a' => 'audio/mp4',
      _ => 'application/octet-stream',
    };
  }
}
