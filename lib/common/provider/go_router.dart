import 'package:b612_project_team3/common/view/root_tab.dart';
import 'package:b612_project_team3/common/view/splash_screen.dart';
import 'package:b612_project_team3/navigation/view/drive_done_screen.dart';
import 'package:b612_project_team3/navigation/view/navigation_detail_screen.dart';
import 'package:b612_project_team3/user/view/login_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final routerProvider = Provider<GoRouter>(
  (ref) {
    return GoRouter(
      routes: [
        GoRoute(
          path: '/',
          name: RootTab.routeName,
          builder: (_, __) => const RootTab(),
        ),
        GoRoute(
          path: '/splash',
          name: SplashScreen.routeName,
          builder: (_, __) => const SplashScreen(),
        ),
        GoRoute(
          path: '/login',
          name: LoginScreen.routeName,
          builder: (_, __) => const LoginScreen(),
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
      ],
      initialLocation: '/splash',
      redirect: (context, state) {
        return null;

        // return state.uri.toString() == '/splash' ? '/login' : null;
      },
    );
  },
);
