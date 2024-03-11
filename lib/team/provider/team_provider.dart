import 'package:b612_project_team3/common/const/data.dart';
import 'package:b612_project_team3/common/model/cursor_pagination_model.dart';
import 'package:b612_project_team3/team/model/team_model.dart';
import 'package:b612_project_team3/team/repository/team_repository.dart';
import 'package:b612_project_team3/user/repository/user_info_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedTeamProvider = StateProvider<String>((ref) => SOLO);

final teamProvider =
    StateNotifierProvider<TeamStateNotifier, CursorPaginationBase>((ref) {
  final teamRepository = ref.watch(teamRepositoryProvider);
  final userInfoRepository = ref.watch(userInfoRepositoryProvider);

  return TeamStateNotifier(
    teamRepository: teamRepository,
    userInfoRepository: userInfoRepository,
  );
});

class TeamStateNotifier extends StateNotifier<CursorPaginationBase> {
  final TeamRepository teamRepository;
  final UserInfoRepository userInfoRepository;
  final size = 15;
  int page = 0;
  bool hasMore = true;

  TeamStateNotifier({
    required this.teamRepository,
    required this.userInfoRepository,
  }) : super(CursorPaginationLoading()) {
    getCurrentTeamInfoPaginate();
  }

  Future<void> getCurrentTeamInfoPaginate({
    bool forceRefetch = false,
  }) async {
    if (forceRefetch == true) {
      state = CursorPaginationLoading();
      page = 0;
      hasMore = true;
    }

    if (!hasMore ||
        state is CursorPaginationError ||
        state is CursorPaginationFetchingMore) {
      return;
    }

    // 기존에 데이터가 있고 추가로 데이터를 더 가져오는 상태
    late CursorPagination<TeamModel> pState;
    if (state is CursorPagination<TeamModel>) {
      pState = state as CursorPagination<TeamModel>;
      state = CursorPaginationFetchingMore(data: pState.data);
    }

    try {
      final pPage = page;
      final resp = await userInfoRepository.getTeam(
        page: page,
        size: size,
      );
      page = pPage + 1;
      if (resp.length < size) {
        hasMore = false;
      }

      // 기존에 데이터가 있고 추가로 데이터를 더 가져온 상태
      if (state is CursorPagination<TeamModel>) {
        state = CursorPagination(
          data: [
            ...pState.data,
            ...resp,
          ],
        );
      }
      // 데이터를 처음 가져온 경우
      else if (state is CursorPaginationLoading) {
        state = CursorPagination(data: resp);
      }
    } catch (e) {
      print(e);
      state = CursorPaginationError(message: '데이터를 가져오지 못했습니다.');
    }
  }

  Future<bool> addNewTeam(TeamModel teamModel) async {
    final resp = await teamRepository.addTeam(body: teamModel);

    if (resp == "팀 생성 완료") {
      getCurrentTeamInfoPaginate(forceRefetch: true);

      return true;
    } else {
      return false;
    }
  }

  Future<bool> joinTeam(JoinTeamModel joinTeamModel) async {
    try {
      final resp = await teamRepository.joinTeam(body: joinTeamModel);

      if (resp == "${joinTeamModel.name}에 가입완료") {
        getCurrentTeamInfoPaginate(forceRefetch: true);

        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }
}
