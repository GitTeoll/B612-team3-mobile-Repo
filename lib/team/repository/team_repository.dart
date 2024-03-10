import 'package:b612_project_team3/common/const/data.dart';
import 'package:b612_project_team3/common/dio/dio.dart';
import 'package:b612_project_team3/team/model/team_model.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/retrofit.dart';

part 'team_repository.g.dart';

final teamRepositoryProvider = Provider<TeamRepository>((ref) {
  final dio = ref.watch(dioProvider);

  return TeamRepository(dio, baseUrl: 'http://$ip/team');
});

@RestApi()
abstract class TeamRepository {
  factory TeamRepository(Dio dio, {String baseUrl}) = _TeamRepository;

  @GET('/info')
  @Headers({
    'accessToken': 'true',
  })
  Future<TeamDetailModel> getTeamInfo(
    @Query('name') String name,
  );

  @GET('/search')
  @Headers({
    'accessToken': 'true',
  })
  Future<List<TeamModel>> searchTeam({
    // [name, address] 중 하나
    @Query('kind') required String kind,
    @Query('keyword') required String keyword,
    @Query('page') required int page,
    @Query('size') required int size,
  });

  @POST('/save')
  @Headers({
    'accessToken': 'true',
  })
  Future<String> addTeam({
    @Body() required TeamModel body,
  });

  @POST('/join')
  @Headers({
    'accessToken': 'true',
  })
  Future<String> joinTeam({
    @Body() required JoinTeamModel body,
  });
}
