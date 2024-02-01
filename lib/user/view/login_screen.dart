import 'package:b612_project_team3/common/layout/default_layout.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  static String get routeName => 'login';

  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {},
            child: Center(
              child: Image.asset(
                'assets/images/kakao_login/ko/kakao_login_large_narrow.png',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
