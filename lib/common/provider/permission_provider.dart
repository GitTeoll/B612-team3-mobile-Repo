import 'package:b612_project_team3/common/model/permission_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

final permissionProvider =
    StateNotifierProvider<PermissionStateNotifier, PermissionBase>(
  (ref) => PermissionStateNotifier(),
);

class PermissionStateNotifier extends StateNotifier<PermissionBase> {
  PermissionStateNotifier() : super(PermissionLoading()) {
    checkPermission();
  }

  Future<void> checkPermission() async {
    // 위치 서비스 활성화 여부 확인
    final isLocationEnabled = await Geolocator.isLocationServiceEnabled();

    if (!isLocationEnabled) {
      // 위치 서비스 활성화 안 됨
      state = PermissionDenied(message: '위치 서비스를 활성화해주세요.');
      return;
    }

    // 위치 권한 확인
    LocationPermission checkedPermission = await Geolocator.checkPermission();

    // 위치 권한 거절됨
    if (checkedPermission == LocationPermission.denied) {
      // 위치 권한 요청하기
      checkedPermission = await Geolocator.requestPermission();

      if (checkedPermission == LocationPermission.denied) {
        state = PermissionDenied(message: '위치 권한을 허가해주세요.');
        return;
      }
    }

    // 위치 권한 거절됨 (앱에서 재요청 불가)
    if (checkedPermission == LocationPermission.deniedForever) {
      state = PermissionDenied(message: '앱의 위치 권한을 설정에서 허가해주세요.');
      return;
    }

    // 위 모든 조건이 통과되면 위치 권한 허가 완료
    state = PermissionAccepted();
    return;
  }
}
