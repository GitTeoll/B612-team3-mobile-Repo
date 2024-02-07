import 'package:b612_project_team3/common/layout/default_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CheckPermissionScreen extends ConsumerWidget {
  static String get routeName => 'checkpermission';

  const CheckPermissionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const DefaultLayout(
      child: Center(
        child: Text(
          '앱을 이용하려면 GPS 기능과 권한이 설정되어 있어야 합니다.\nGPS 기능이 사용 설정되어 있는지 확인해주세요.\n설정에서 앱의 위치 권한이 허가되어 있는지 확인해주세요.\n설정 후에 앱을 재시작 해주세요.',
        ),
      ),
    );
  }
}
