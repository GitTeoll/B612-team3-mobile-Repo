import 'package:b612_project_team3/common/const/data.dart';
import 'package:b612_project_team3/common/dio/dio.dart';
import 'package:b612_project_team3/team/model/team_model.dart';
import 'package:b612_project_team3/user/model/user_model.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/retrofit.dart';

part 'user_info_repository.g.dart';

final userInfoRepositoryProvider = Provider<UserInfoRepository>(
  (ref) {
    final dio = ref.watch(dioProvider);

    return UserInfoRepository(dio, baseUrl: 'http://$ip/user');
  },
);

// http://$ip/user
@RestApi()
abstract class UserInfoRepository {
  factory UserInfoRepository(Dio dio, {String baseUrl}) = _UserInfoRepository;

  @GET('/info')
  @Headers({
    'accessToken': 'true',
  })
  Future<UserModel> getInfo();

  @GET('/team')
  @Headers({
    'accessToken': 'true',
  })
  Future<List<TeamModel>> getTeam({
    @Query('page') required int page,
    @Query('size') required int size,
  });

  @POST('/edit')
  @Headers({
    'accessToken': 'true',
  })
  Future<UserModel> editInfo({
    @Body() required UserModel body,
  });
}
