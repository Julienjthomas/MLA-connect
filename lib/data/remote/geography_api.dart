import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/geography/constituency_response.dart';
import '../models/geography/local_body_response.dart';
import '../models/geography/ward_response.dart';

part 'geography_api.g.dart';

@RestApi()
abstract class GeographyApi {
  factory GeographyApi(Dio dio, {String? baseUrl}) = _GeographyApi;

  @GET('/constituencies')
  Future<List<ConstituencyResponse>> getConstituencies();

  @GET('/constituencies/{constituencyId}/local-bodies')
  Future<List<LocalBodyResponse>> getLocalBodies(
    @Path('constituencyId') String constituencyId,
  );

  @GET('/constituencies/{constituencyId}/local-bodies/{localBodyId}/wards')
  Future<List<WardResponse>> getWards(
    @Path('constituencyId') String constituencyId,
    @Path('localBodyId') String localBodyId,
  );
}
