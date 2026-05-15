typedef StorageRef = ({String bucket, String objectPath});

/// Parses `https://.../storage/v1/object/public/<bucket>/<path>` → bucket + objectPath.
StorageRef? parseSupabasePublicObjectUrl(String? url) {
  if (url == null || url.isEmpty) return null;
  final match = RegExp(r'/storage/v1/object/public/([^/?#]+)/(.+?)(\?.*)?$').firstMatch(url);
  if (match == null) return null;
  return (bucket: match.group(1)!, objectPath: Uri.decodeComponent(match.group(2)!));
}

/// Parses `<bucket>/<path>` storage paths stored in `media_attachments.storage_path`.
StorageRef? parseBucketAndPathFromStoragePath(String? storagePath) {
  if (storagePath == null || storagePath.isEmpty) return null;
  final idx = storagePath.indexOf('/');
  if (idx <= 0) return null;
  return (bucket: storagePath.substring(0, idx), objectPath: storagePath.substring(idx + 1));
}
