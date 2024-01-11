import 'package:b612_project_team3/common/view/root_tab.dart';
import 'package:b612_project_team3/common/view/splash_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final routerProvider = Provider<GoRouter>((ref) {
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
    ],
    initialLocation: '/splash',
  );
});
