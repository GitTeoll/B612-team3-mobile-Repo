import 'package:b612_project_team3/user/model/user_model.dart';
import 'package:b612_project_team3/user/provider/auth_provider.dart';
import 'package:b612_project_team3/user/provider/user_info_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 좌측 상단 메뉴 추가
class CustomDrawer extends ConsumerWidget {
  const CustomDrawer({
    super.key,
  });

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
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${userInfo.name} 님',
                      ),
                      GestureDetector(
                        onTap: () {
                          ref.read(authProvider.notifier).logout();
                        },
                        child: const Text(
                          '로그아웃',
                          style: TextStyle(
                            fontSize: 12,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  )
                : const Text('에러'),
          ),
          const ListTile(
            title: Text('메뉴 항목1'),
          )
        ],
      ),
    );
  }
}
