import 'package:b612_project_team3/common/layout/default_layout.dart';
import 'package:b612_project_team3/common/model/cursor_pagination_model.dart';
import 'package:b612_project_team3/team/component/favorite_team_card.dart';
import 'package:b612_project_team3/team/component/team_card.dart';
import 'package:b612_project_team3/team/model/team_model.dart';
import 'package:b612_project_team3/team/provider/team_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SelectTeamScreen extends ConsumerStatefulWidget {
  static String get routeName => 'selectteam';

  const SelectTeamScreen({super.key});

  @override
  ConsumerState<SelectTeamScreen> createState() => _TeamScreenState();
}

class _TeamScreenState extends ConsumerState<SelectTeamScreen> {
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

    return DefaultLayout(
      title: '팀 선택',
      child: CustomScrollView(
        controller: controller,
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "My team",
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  Center(
                    child: favoriteCardCount == 0
                        ? const Text('팀이 없습니다.\n팀을 새로 만들거나 팀에 가입해주세요.')
                        : FavoriteTeamCard(
                            onTap: (index) {
                              context.pop(cp.data[index].name);
                            },
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
                    onTap: () {
                      context.pop(cp.data[index + favoriteCardMaxCount].name);
                    },
                    teamModel: cp.data[index + favoriteCardMaxCount],
                  );
                },
                separatorBuilder: (_, __) => const SizedBox(height: 16.0),
              ),
            ),
        ],
      ),
    );
  }
}
