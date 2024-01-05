import 'package:b612_project_team3/common/layout/default_layout.dart';
import 'package:b612_project_team3/community/view/community_screen.dart';
import 'package:b612_project_team3/course/view/coures_screen.dart';
import 'package:b612_project_team3/navigation/view/navigation_screen.dart';
import 'package:b612_project_team3/team/view/team_screen.dart';
import 'package:flutter/material.dart';

class RootTab extends StatefulWidget {
  static String get routeName => 'home';

  const RootTab({super.key});

  @override
  State<RootTab> createState() => _RootTabState();
}

class _RootTabState extends State<RootTab> with SingleTickerProviderStateMixin {
  late TabController controller;

  int index = 0;

  @override
  void initState() {
    super.initState();

    controller = TabController(length: 4, vsync: this);

    controller.addListener(tabListener);
  }

  @override
  void dispose() {
    controller.removeListener(tabListener);

    super.dispose();
  }

  void tabListener() {
    setState(() {
      index = controller.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '자전거 주행 앱?',
      bottomNavigationBar: BottomNavigationBar(
        selectedFontSize: 12,
        unselectedFontSize: 12,
        type: BottomNavigationBarType.fixed,
        onTap: (int index) {
          controller.animateTo(index);
        },
        currentIndex: index,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_bike_outlined),
            label: '주변코스',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.groups),
            label: '팀',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.forum_outlined),
            label: '게시판',
          ),
        ],
      ),
      child: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: controller,
        children: const [
          NavigationScreen(),
          CourseScreen(),
          TeamScreen(),
          CommunityScreen(),
        ],
      ),
    );
  }
}
