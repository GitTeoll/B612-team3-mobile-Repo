import 'package:b612_project_team3/common/layout/default_layout.dart';
import 'package:b612_project_team3/user/model/user_model.dart';
import 'package:b612_project_team3/user/provider/user_info_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerWidget {
  static String get routeName => 'login';

  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isLoading = false;

    return DefaultLayout(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () async {
              if (isLoading) {
                return;
              }
              isLoading = true;

              if (await ref.read(userInfoProvider.notifier).login()
                  is UserModelError) {
                isLoading = false;
              }
            },
            child: Center(
              child: Image.asset(
                'assets/images/kakao_login/ko/kakao_login_large_narrow.png',
                width: MediaQuery.of(context).size.width / 2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
