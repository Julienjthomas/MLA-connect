import 'package:freezed_annotation/freezed_annotation.dart';

part 'otp_send_request.freezed.dart';
part 'otp_send_request.g.dart';

@freezed
abstract class OtpSendRequest with _$OtpSendRequest {
  const factory OtpSendRequest({
    required String phone,
  }) = _OtpSendRequest;

  factory OtpSendRequest.fromJson(Map<String, dynamic> json) =>
      _$OtpSendRequestFromJson(json);
}
