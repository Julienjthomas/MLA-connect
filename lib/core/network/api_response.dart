/// Generic wrapper for API responses.
///
/// Use when endpoints return a consistent envelope like:
/// ```json
/// { "data": ..., "message": "...", "meta": { "page": 1, "total": 42 } }
/// ```
class ApiResponse<T> {
  const ApiResponse({
    required this.data,
    this.message,
    this.meta,
  });

  final T data;
  final String? message;
  final Map<String, dynamic>? meta;

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromData,
  ) {
    return ApiResponse(
      data: fromData(json['data']),
      message: json['message'] as String?,
      meta: json['meta'] as Map<String, dynamic>?,
    );
  }
}
