import 'package:b612_project_team3/user/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:b612_project_team3/user/model/user_model.dart';
import 'package:b612_project_team3/user/provider/user_info_provider.dart';
import 'package:go_router/go_router.dart';

class CustomDrawer extends ConsumerWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfo = ref.watch(userInfoProvider);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.blue),
            child: userInfo is UserModel
                ? Text('${userInfo.name} 님')
                : const Text('에러'),
          ),
          const ListTile(
            title: Text('메뉴 항목1'),
          ),
          ListTile(
            title: const Text('로그아웃'),
            onTap: () {
              ref.read(authProvider).logout();
              context.go('/login'); // 사용자를 로그인 화면으로 이동
            },
          ),
        ],
      ),
    );
  }
}
