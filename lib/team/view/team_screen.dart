import 'package:b612_project_team3/common/model/cursor_pagination_model.dart';
import 'package:b612_project_team3/team/component/favorite_team_card.dart';
import 'package:b612_project_team3/team/component/team_card.dart';
import 'package:b612_project_team3/team/model/team_model.dart';
import 'package:b612_project_team3/team/provider/team_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class TeamScreen extends ConsumerStatefulWidget {
  const TeamScreen({super.key});

  @override
  ConsumerState<TeamScreen> createState() => _TeamScreenState();
}

class _TeamScreenState extends ConsumerState<TeamScreen> {
  final favoriteCardMaxCount = 5;

  final ScrollController controller = ScrollController();
  late CursorPagination<TeamModel> cp;
  late int favoriteCardCount;
  late int normalCardCount;
  bool lock = false;

  @override
  void initState() {
    super.initState();

    controller.addListener(listener);
  }

  void listener() async {
    if (ref.read(teamProvider.notifier).hasMore &&
        !lock &&
        controller.offset > controller.position.maxScrollExtent - 300) {
      lock = true;
      await ref.read(teamProvider.notifier).getCurrentTeamInfoPaginate();
      lock = false;
    }
  }

  @override
  void dispose() {
    controller.removeListener(listener);
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final team = ref.watch(teamProvider);

    if (team is CursorPagination || team is CursorPaginationFetchingMore) {
      cp = team as CursorPagination<TeamModel>;

      if (cp.data.length > favoriteCardMaxCount) {
        favoriteCardCount = favoriteCardMaxCount;
        normalCardCount = cp.data.length - favoriteCardMaxCount;
      } else {
        favoriteCardCount = cp.data.length;
        normalCardCount = 0;
      }
    }

    if (team is CursorPaginationLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (team is CursorPaginationError) {
      return Center(
        child: Text(team.message),
      );
    }

    return CustomScrollView(
      controller: controller,
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "My team",
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: () {
                              showModalBottomSheet(
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(16.0),
                                    topRight: Radius.circular(16.0),
                                  ),
                                ),
                                context: context,
                                builder: (context) {
                                  return SizedBox(
                                    height: 150,
                                    width: double.infinity,
                                    child: Column(
                                      children: [
                                        Flexible(
                                          flex: 1,
                                          fit: FlexFit.tight,
                                          child: TextButton(
                                            onPressed: () {
                                              context.go('/addnewteam');
                                              context.pop();
                                            },
                                            child: const Text('새 팀 만들기'),
                                          ),
                                        ),
                                        Flexible(
                                          flex: 1,
                                          fit: FlexFit.tight,
                                          child: TextButton(
                                            onPressed: () {
                                              context.go('/searchteam');
                                              context.pop();
                                            },
                                            child: const Text('팀 찾기'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                            icon: const Icon(Icons.add_circle_outline_outlined),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Center(
                  child: favoriteCardCount == 0
                      ? const Text('팀이 없습니다.\n팀을 새로 만들거나 팀에 가입해주세요.')
                      : FavoriteTeamCard(
                          cp: cp,
                          favoriteCardCount: favoriteCardCount,
                        ),
                ),
              ],
            ),
          ),
        ),
        if (cp.data.isNotEmpty)
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverList.separated(
              itemCount: normalCardCount + 1,
              itemBuilder: (context, index) {
                if (index == normalCardCount) {
                  return Center(
                    child: cp is CursorPaginationFetchingMore
                        ? const CircularProgressIndicator()
                        : const Text('마지막 데이터입니다.'),
                  );
                }

                return TeamCard(
                  teamModel: cp.data[index + favoriteCardMaxCount],
                );
              },
              separatorBuilder: (_, __) => const SizedBox(height: 16.0),
            ),
          ),
      ],
    );
  }
}
