import 'package:b612_project_team3/common/model/permission_model.dart';
import 'package:b612_project_team3/common/provider/permission_provider.dart';
import 'package:b612_project_team3/common/view/check_permission_screen.dart';
import 'package:b612_project_team3/common/view/root_tab.dart';
import 'package:b612_project_team3/common/view/splash_screen.dart';
import 'package:b612_project_team3/navigation/view/drive_done_screen.dart';
import 'package:b612_project_team3/navigation/view/navigation_detail_screen.dart';
import 'package:b612_project_team3/team/view/add_new_team_screen.dart';
import 'package:b612_project_team3/team/view/search_team_screen.dart';
import 'package:b612_project_team3/user/model/user_model.dart';
import 'package:b612_project_team3/user/provider/user_info_provider.dart';
import 'package:b612_project_team3/user/view/login_screen.dart';
import 'package:b612_project_team3/user/view/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final authProvider = ChangeNotifierProvider<AuthProvider>((ref) {
  return AuthProvider(ref: ref);
});

class AuthProvider extends ChangeNotifier {
  final Ref ref;

  AuthProvider({
    required this.ref,
  }) {
    ref.listen<PermissionBase>(
      permissionProvider,
      (previous, next) {
        if (previous != next) {
          notifyListeners();
        }
      },
    );

    ref.listen<UserModelBase?>(
      userInfoProvider,
      (previous, next) {
        if (previous != next) {
          notifyListeners();
        }
      },
    );
  }

  List<GoRoute> get routes => [
        GoRoute(
          path: '/',
          name: RootTab.routeName,
          builder: (_, __) => const RootTab(),
          routes: [
            GoRoute(
              path: 'addnewteam',
              name: AddNewTeamScreen.routeName,
              builder: (_, __) => const AddNewTeamScreen(),
            ),
            GoRoute(
              path: 'searchteam',
              name: SearchTeamScreen.routeName,
              builder: (_, __) => const SearchTeamScreen(),
            ),
          ],
        ),
        GoRoute(
          path: '/splash',
          name: SplashScreen.routeName,
          builder: (_, __) => const SplashScreen(),
        ),
        GoRoute(
          path: '/checkpermission',
          name: CheckPermissionScreen.routeName,
          builder: (_, __) => const CheckPermissionScreen(),
        ),
        GoRoute(
          path: '/login',
          name: LoginScreen.routeName,
          builder: (_, __) => const LoginScreen(),
        ),
        GoRoute(
          path: '/register',
          name: RegisterScreen.routeName,
          builder: (_, __) => const RegisterScreen(),
        ),
        GoRoute(
          path: '/navigation',
          name: NavigationDetailScreen.routeName,
          builder: (_, __) => const NavigationDetailScreen(),
        ),
        GoRoute(
          path: '/drivedone',
          name: DriveDoneScreen.routeName,
          builder: (_, __) => const DriveDoneScreen(),
        ),
      ];

  void logout() {
    ref.read(userInfoProvider.notifier).logout();
  }

  // SplashScreen
  // 앱을 처음 시작했을때
  // 권한 및 토큰이 존재하는지 확인하고
  // 로그인 스크린으로 보내줄지
  // 홈 스크린으로 보내줄지
  // 권한 확인 스크린으로 보내줄지 확인하는 과정이 필요하다.
  String? redirectLogic(BuildContext _, GoRouterState state) {
    final PermissionBase permission = ref.read(permissionProvider);

    if (permission is PermissionLoading) {
      return null;
    }

    // 권한 없는데
    // 권한 체크 페이지에 있으면 그대로 두고
    // 권한 체크 페이지에 없으면 권한 체크 페이지로 이동
    if (permission is PermissionDenied) {
      return state.fullPath == '/checkpermission' ? null : '/checkpermission';
    }

    final UserModelBase? user = ref.read(userInfoProvider);

    final logginIn = state.fullPath == '/login';

    // 유저 정보 없는데
    // 로그인중이면 그대로 로그인 페이지에 두고
    // 만약에 로그인중이 아니라면 로그인 페이지로 이동
    if (user == null) {
      return logginIn ? null : '/login';
    }

    // user가 null이 아님

    // Usermodel
    // 사용자 정보가 있지만 속성중에 null 값이 있는 경우
    // 가입을 하지 않았으므로 가입 페이지로 이동
    // 사용자 정보가 있고 가입도 완료된 경우, 로그인 중이거나 현재 위치가 SplashScreen 또는 RegisterScreen이면
    // 홈으로 이동
    if (user is UserModel) {
      if (user.address == null || user.age == null || user.gender == null) {
        return '/register';
      }
      return logginIn ||
              state.fullPath == '/splash' ||
              state.fullPath == '/register'
          ? '/'
          : null;
    }

    // UserModelError
    if (user is UserModelError) {
      return !logginIn ? '/login' : null;
    }

    return null;
  }
}
