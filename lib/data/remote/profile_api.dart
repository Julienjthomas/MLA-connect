import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/profile/citizen_profile.dart';
import '../models/profile/personal_info_request.dart';
import '../models/profile/update_profile_request.dart';

part 'profile_api.g.dart';

@RestApi()
abstract class ProfileApi {
  factory ProfileApi(Dio dio, {String? baseUrl}) = _ProfileApi;

  @GET('/citizens/:citizenId/profile')
  Future<CitizenProfile> getProfile();

  @POST('/citizens/:citizenId/profile/update')
  Future<void> updateProfile(@Body() UpdateProfileRequest request);

  @POST('/citizens/:citizenId/basic-info/personal-info')
  Future<void> savePersonalInfo(@Body() PersonalInfoRequest request);

  @PUT('/citizens/:citizenId/settings')
  Future<void> updateSettings(@Body() Map<String, dynamic> settings);
}
