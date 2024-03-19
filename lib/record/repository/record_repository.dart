import 'package:b612_project_team3/common/const/data.dart';
import 'package:b612_project_team3/common/dio/dio.dart';
import 'package:b612_project_team3/record/model/record_model.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/retrofit.dart';

part 'record_repository.g.dart';

final recordRepositoryProvider = Provider<RecordRepository>((ref) {
  final dio = ref.watch(dioProvider);

  return RecordRepository(dio, baseUrl: 'http://$ip/course');
});

@RestApi()
abstract class RecordRepository {
  factory RecordRepository(Dio dio, {String baseUrl}) = _RecordRepository;

  @GET('/my')
  @Headers({
    'accessToken': 'true',
  })
  Future<List<RecordModel>> getMyRecord();

  @POST('/save')
  @Headers({
    'accessToken': 'true',
  })
  Future<String> saveRecord({
    @Body() required DriveDoneRecordModel body,
  });
}
