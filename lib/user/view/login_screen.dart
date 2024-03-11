import 'package:b612_project_team3/common/layout/default_layout.dart';
import 'package:b612_project_team3/team/provider/team_provider.dart';
import 'package:b612_project_team3/user/model/user_model.dart';
import 'package:b612_project_team3/user/provider/user_info_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static String get routeName => 'login';

  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () async {
              // 만약 기존에 teamProvider가 존재하고 있다면
              // 로그인 하면서 삭제해줌
              // 로그아웃하고 다른 아이디로 다시 로그인하는 경우
              // teamProvider가 남아있을 수 있음
              if (ref.exists(teamProvider)) {
                ref.invalidate(teamProvider);
              }

              if (isLoading) {
                return;
              }
              setState(() {
                isLoading = true;
              });

              if (await ref.read(userInfoProvider.notifier).login()
                  is UserModelError) {
                setState(() {
                  isLoading = false;
                });
              }
            },
            child: Center(
              child: isLoading
                  ? const CircularProgressIndicator()
                  : Image.asset(
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
