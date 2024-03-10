import 'package:b612_project_team3/team/model/team_model.dart';
import 'package:b612_project_team3/team/repository/team_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final teamProvider =
    StateNotifierProvider<TeamStateNotifier, List<TeamModel>>((ref) {
  final teamRepository = ref.watch(teamRepositoryProvider);

  return TeamStateNotifier(
    teamRepository: teamRepository,
  );
});

class TeamStateNotifier extends StateNotifier<List<TeamModel>> {
  final TeamRepository teamRepository;

  TeamStateNotifier({
    required this.teamRepository,
  }) : super([]) {
    getCurrentTeamInfo();
  }

  void getCurrentTeamInfo() {}

  Future<bool> addNewTeam(TeamModel teamModel) async {
    final resp = await teamRepository.addTeam(body: teamModel);

    if (resp == "팀 생성 완료") {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> joinTeam(JoinTeamModel joinTeamModel) async {
    final resp = await teamRepository.joinTeam(body: joinTeamModel);

    if (resp == "${joinTeamModel.name}에 가입완료") {
      return true;
    } else {
      return false;
    }
  }
}
