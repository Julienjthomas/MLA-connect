List<String> submissionMediaRefsFromJson(Map<String, dynamic> json) {
  return (json['media_attachments'] as List?)
          ?.map((raw) {
            final media = Map<String, dynamic>.from(raw as Map);
            final url = media['url'] as String?;
            final storagePath = media['storage_path'] as String?;
            if (url != null && url.trim().isNotEmpty) return url.trim();
            if (storagePath != null && storagePath.trim().isNotEmpty) {
              return storagePath.trim();
            }
            return '';
          })
          .where((value) => value.isNotEmpty)
          .toList() ??
      [];
}
