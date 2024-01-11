import 'package:b612_project_team3/common/layout/default_layout.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';

// 앱 실행 구동 화면
// 앱 실행전, 필요한 권한 확인 (ex. 위치권한)
// 필요한 권한 허용된 것이 확인되면 root tab으로 이동
// TODO: 현재 로그인 되었는지 확인하는 부분도 나중에 추가 필요함
class SplashScreen extends StatelessWidget {
  static String get routeName => 'splash';

  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: FutureBuilder(
        future: checkPermission(),
        builder: (context, snapshot) {
          // 로딩 상태
          if (!snapshot.hasData &&
              snapshot.connectionState == ConnectionState.waiting) {
            return renderLoading(context);
          }

          // 권한 허가된 상태
          if (snapshot.data == '위치 권한이 허가 되었습니다.') {
            WidgetsBinding.instance.addPostFrameCallback(
              (_) => context.go('/'),
            );
            return renderLoading(context);
          }

          // 권한 없는 상태
          return Center(
            child: Text(
              snapshot.data.toString(),
            ),
          );
        },
      ),
    );
  }

  SizedBox renderLoading(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('로고 들어갈자리'),
          SizedBox(height: 16.0),
          CircularProgressIndicator(),
        ],
      ),
    );
  }
}

Future<String> checkPermission() async {
  // 위치 서비스 활성화 여부 확인
  final isLocationEnabled = await Geolocator.isLocationServiceEnabled();

  if (!isLocationEnabled) {
    // 위치 서비스 활성화 안 됨
    return '위치 서비스를 활성화해주세요.';
  }

  // 위치 권한 확인
  LocationPermission checkedPermission = await Geolocator.checkPermission();

  // 위치 권한 거절됨
  if (checkedPermission == LocationPermission.denied) {
    // 위치 권한 요청하기
    checkedPermission = await Geolocator.requestPermission();

    if (checkedPermission == LocationPermission.denied) {
      return '위치 권한을 허가해주세요.';
    }
  }

  // 위치 권한 거절됨 (앱에서 재요청 불가)
  if (checkedPermission == LocationPermission.deniedForever) {
    return '앱의 위치 권한을 설정에서 허가해주세요.';
  }

  // 위 모든 조건이 통과되면 위치 권한 허가 완료
  return '위치 권한이 허가 되었습니다.';
}
