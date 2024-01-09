import 'package:b612_project_team3/common/provider/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';

void main() async {
  await dotenv.load(fileName: 'assets/env/.env.sample');

  /// 라이브러리 메모리에 appKey 등록
  /// 지도가 호출되기 전에만 세팅해 주면 됩니다.
  AuthRepository.initialize(appKey: dotenv.env['APP_KEY'] ?? '');

  runApp(
    const ProviderScope(
      child: _App(),
    ),
  );
}

class _App extends ConsumerWidget {
  const _App();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
