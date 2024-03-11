import 'package:b612_project_team3/common/component/search_box.dart';
import 'package:b612_project_team3/common/layout/default_layout.dart';
import 'package:b612_project_team3/common/model/cursor_pagination_model.dart';
import 'package:b612_project_team3/team/component/team_card.dart';
import 'package:b612_project_team3/team/model/team_model.dart';
import 'package:b612_project_team3/team/provider/search_team_provider.dart';
import 'package:b612_project_team3/team/provider/team_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SearchTeamScreen extends ConsumerStatefulWidget {
  static String get routeName => 'searchteam';

  const SearchTeamScreen({super.key});

  @override
  ConsumerState<SearchTeamScreen> createState() => _SearchTeamScreenState();
}

class _SearchTeamScreenState extends ConsumerState<SearchTeamScreen> {
  CursorPaginationBase? searchTeam;
  final ScrollController controller = ScrollController();
  String filter = 'name';
  String? keyword;
  bool lock = false;

  @override
  void initState() {
    super.initState();

    controller.addListener(listener);
  }

  void listener() async {
    if (keyword != null &&
        ref.read(searchTeamProvider((filter, keyword!)).notifier).hasMore &&
        !lock &&
        controller.offset > controller.position.maxScrollExtent - 300) {
      lock = true;
      await ref
          .read(searchTeamProvider((filter, keyword!)).notifier)
          .searchTeamPaginate();
      lock = false;
    }
  }

  @override
  void dispose() {
    controller.removeListener(listener);
    controller.dispose();

    super.dispose();
  }

  void onSubmitted(String value) {
    setState(() {
      keyword = value;
    });
  }

  void onCardTab() {}

  @override
  Widget build(BuildContext context) {
    if (keyword != null) {
      searchTeam = ref.watch(searchTeamProvider((filter, keyword!)));
    }

    return DefaultLayout(
      appBarHeight: 80.0,
      leadingWidth: 36.0,
      titleSpacing: 8.0,
      titleWidget: SearchBox(
        onFieldSubmitted: onSubmitted,
        hintText: '팀 검색',
        autofocus: true,
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(50.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              const Text('검색필터 :'),
              const SizedBox(
                width: 16.0,
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    filter = 'name';
                  });
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16.0), // and this
                ),
                child: Row(
                  children: [
                    if (filter == 'name')
                      const Row(
                        children: [
                          Icon(Icons.check),
                          SizedBox(
                            width: 8.0,
                          ),
                        ],
                      ),
                    const Text('팀 이름'),
                  ],
                ),
              ),
              const SizedBox(
                width: 16.0,
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    filter = 'address';
                  });
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16.0), // and this
                ),
                child: Row(
                  children: [
                    if (filter == 'address')
                      const Row(
                        children: [
                          Icon(Icons.check),
                          SizedBox(
                            width: 8.0,
                          ),
                        ],
                      ),
                    const Text('팀 활동 주소'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: searchTeam != null && searchTeam is! CursorPaginationError
            ? ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                controller: controller,
                itemBuilder: (context, index) {
                  final cp = searchTeam! as CursorPagination<TeamModel>;

                  if (index == cp.data.length) {
                    return Center(
                      child: cp is CursorPaginationFetchingMore
                          ? const CircularProgressIndicator()
                          : const Text('마지막 데이터입니다.'),
                    );
                  }

                  return TeamCard(
                    teamModel: cp.data[index],
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content:
                                Text("'${cp.data[index].name}' 에 가입하시겠습니까?"),
                            actions: [
                              ElevatedButton(
                                onPressed: () async {
                                  bool commit = false;

                                  if (await ref
                                      .read(teamProvider.notifier)
                                      .joinTeam(
                                        JoinTeamModel(
                                          name: cp.data[index].name,
                                          joinedAt:
                                              DateTime.now().toIso8601String(),
                                        ),
                                      )) {
                                    commit = true;
                                  }

                                  context.pop();

                                  AlertDialog(
                                    content: Text(commit
                                        ? '가입이 완료되었습니다.'
                                        : '오류가 발생했습니다.'),
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () {
                                          context.pop();
                                        },
                                        child: const Text('확인'),
                                      ),
                                    ],
                                  );
                                },
                                child: const Text("예"),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  context.pop();
                                },
                                child: const Text("아니요"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  );
                },
                separatorBuilder: (_, __) => const SizedBox(height: 16.0),
                itemCount:
                    (searchTeam as CursorPagination<TeamModel>).data.length + 1,
              )
            : searchTeam is CursorPaginationError
                ? Center(
                    child: Text((searchTeam! as CursorPaginationError).message),
                  )
                : const SizedBox(),
      ),
    );
  }
}
