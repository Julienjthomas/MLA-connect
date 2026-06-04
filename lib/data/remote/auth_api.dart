import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../core/network/api_endpoints.dart';
import '../models/auth/auth_response.dart';
import '../models/auth/otp_send_request.dart';
import '../models/auth/otp_verify_request.dart';

part 'auth_api.g.dart';

@RestApi()
abstract class AuthApi {
  factory AuthApi(Dio dio, {String? baseUrl}) = _AuthApi;

  @POST(ApiEndpoints.otpSend)
  Future<void> sendOtp(@Body() OtpSendRequest request);

  @POST(ApiEndpoints.otpVerify)
  Future<AuthResponse> verifyOtp(@Body() OtpVerifyRequest request);
}
