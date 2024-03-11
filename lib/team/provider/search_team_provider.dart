import 'package:b612_project_team3/common/model/cursor_pagination_model.dart';
import 'package:b612_project_team3/team/model/team_model.dart';
import 'package:b612_project_team3/team/repository/team_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final searchTeamProvider = StateNotifierProvider.family.autoDispose<
    SearchTeamStateNotifier, CursorPaginationBase, (String, String)>(
  (ref, param) {
    final teamRepository = ref.watch(teamRepositoryProvider);

    return SearchTeamStateNotifier(
      teamRepository: teamRepository,
      kind: param.$1,
      keyword: param.$2,
    );
  },
);

class SearchTeamStateNotifier extends StateNotifier<CursorPaginationBase> {
  final TeamRepository teamRepository;
  final String kind;
  final String keyword;
  final size = 10;
  int page = 0;
  bool hasMore = true;

  SearchTeamStateNotifier({
    required this.teamRepository,
    required this.kind,
    required this.keyword,
  }) : super(CursorPagination<TeamModel>(data: [])) {
    searchTeamPaginate();
  }

  Future<TeamDetailModel> getTeamDetailInfo(String name) async {
    final resp = await teamRepository.getTeamInfo(name);

    return resp;
  }

  Future<void> searchTeamPaginate() async {
    if (!hasMore) {
      return;
    }

    final pState = state as CursorPagination<TeamModel>;
    final pPage = page;

    state = CursorPaginationFetchingMore(data: pState.data);

    try {
      final resp = await teamRepository.searchTeam(
        kind: kind,
        keyword: keyword,
        page: page,
        size: size,
      );
      page = pPage + 1;

      if (resp.length < size) {
        hasMore = false;
      }

      state = CursorPagination(
        data: [
          ...pState.data,
          ...resp,
        ],
      );
    } catch (e) {
      print(e);
      state = CursorPaginationError(message: '데이터를 가져오지 못했습니다.');
    }
  }
}
