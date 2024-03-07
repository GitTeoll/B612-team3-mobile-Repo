import 'dart:async';
import 'dart:math';

import 'package:b612_project_team3/common/utils/data_utils.dart';
import 'package:b612_project_team3/record/model/record_model.dart';
import 'package:b612_project_team3/record/provider/drive_done_record_model_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_polyline_algorithm/google_polyline_algorithm.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

final currentRecordModelProvider = StateNotifierProvider.autoDispose<
    CurrentRecordModelStateNotifier, RecordModelBase>(
  (ref) => CurrentRecordModelStateNotifier(ref),
);

class CurrentRecordModelStateNotifier extends StateNotifier<RecordModelBase> {
  final Ref _ref;
  StreamSubscription<Position>? _positionStreamSubscription;
  Timer? _timer;
  late LocationSettings locationSettings;
  late DateTime _startTime;
  late double _minLat;
  late double _maxLat;
  late double _minLng;
  late double _maxLng;
  final List<List<double>> _latlngList;
  bool _driveDone = false;
  double? initialBearing;
  GoogleMapController? googleMapController;

  CurrentRecordModelStateNotifier(this._ref)
      : _latlngList = [],
        super(RecordModelLoading()) {
    _startPositionTracking();
  }

  void _startPositionTracking() async {
    WakelockPlus.enable();

    if (defaultTargetPlatform == TargetPlatform.android) {
      locationSettings = AndroidSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        intervalDuration: const Duration(seconds: 1),
        foregroundNotificationConfig: const ForegroundNotificationConfig(
          notificationText: "B612 앱이 주행 기록을 추적하고 있습니다.",
          notificationTitle: "B612",
          enableWakeLock: true,
          setOngoing: true,
        ),
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      locationSettings = AppleSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        activityType: ActivityType.fitness,
        allowBackgroundLocationUpdates: true,
        showBackgroundLocationIndicator: true,
      );
    } else {
      locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
      );
    }

    _positionStreamSubscription =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen(_positionListener);
  }

  void startCameraTracking(GoogleMapController controller) {
    googleMapController = controller;
  }

  LatLngBounds _getLatLngBounds() {
    return LatLngBounds(
      southwest: LatLng(_minLat, _minLng),
      northeast: LatLng(_maxLat, _maxLng),
    );
  }

  void startTimer() async {
    _timer?.cancel();

    final prevState = state as CurrentRecordModel;
    state = prevState.copywith(isStopped: false);

    if (googleMapController != null) {
      await googleMapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(
              prevState.curPosition.latitude,
              prevState.curPosition.longitude,
            ),
            zoom: 17,
            bearing: prevState.curPosition.heading,
          ),
        ),
      );
    }

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) {
        final prevState = state as CurrentRecordModel;
        state = prevState.copywith(elapsedTime: prevState.elapsedTime + 1);
      },
    );
  }

  void stopTimer() {
    _timer?.cancel();

    state = (state as CurrentRecordModel).copywith(isStopped: true);

    if (googleMapController != null) {
      googleMapController!.animateCamera(
        CameraUpdate.newLatLngBounds(_getLatLngBounds(), 80),
      );
    }
  }

  Future<void> stopPositionTracking() async {
    if (_driveDone == true) {
      return;
    }

    _driveDone = true;

    _timer?.cancel();
    await _positionStreamSubscription?.cancel();

    await googleMapController!.moveCamera(
      CameraUpdate.newLatLngBounds(_getLatLngBounds(), 80),
    );

    final driveDoneState = state as CurrentRecordModel;

    _ref.read(driveDoneRecordModelProvider.notifier).completeDrive(
          DriveDoneRecordModel(
            startTime: _startTime.toIso8601String(),
            endTime: driveDoneState.curPosition.timestamp
                .toLocal()
                .toIso8601String(),
            elapsedTime: driveDoneState.elapsedTime,
            totalTravelDistance: DataUtils.decimalPointFix(
                driveDoneState.totalTravelDistance, 3),
            encodedPolyline: encodePolyline(_latlngList),
            startLatLng: _latlngList.first,
            endLatLng: _latlngList.last,
            centerLatLng: [
              DataUtils.decimalPointFix((_minLat + _maxLat) / 2, 6),
              DataUtils.decimalPointFix((_minLng + _maxLng) / 2, 6),
            ],
            southwestLatLng: [_minLat, _minLng],
            northeastLatLng: [_maxLat, _maxLng],
            zoom: DataUtils.decimalPointFix(
                await googleMapController!.getZoomLevel(), 6),
          ),
        );

    WakelockPlus.disable();
  }

  void _updateCameraPosition(Position position) async {
    if (googleMapController != null) {
      final zoom = await googleMapController!.getZoomLevel();

      googleMapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(
              position.latitude,
              position.longitude,
            ),
            zoom: zoom,
            bearing: position.heading,
          ),
        ),
      );
    }
  }

  void _positionListener(Position position) {
    final curLatLng = LatLng(position.latitude, position.longitude);

    // 아직 위치 정보가 하나도 없는 상태면
    // 즉, 아직 시작 전이라면
    // 현재 위치를 폴리라인리스트에 넣고 타이머 시작
    if (state is RecordModelLoading) {
      _minLat = _maxLat = position.latitude;
      _minLng = _maxLng = position.longitude;
      _latlngList.add([position.latitude, position.longitude]);

      _startTime = position.timestamp.toLocal();
      initialBearing = position.heading;

      state = CurrentRecordModel(
        curPosition: position,
        polylineCoordinates: [curLatLng],
      );

      startTimer();
      return;
    }

    // state가 CurrentRecordModel 인 경우
    // 새로운 위치정보를 통해 폴리라인과 주행거리, 현재위치, min/max lat/lng 값을 갱신해준다.
    final prevState = state as CurrentRecordModel;
    final prevPosition = prevState.curPosition;
    double nexttotalTravelDistance = prevState.totalTravelDistance;
    final nextpolylineCoordinates = prevState.polylineCoordinates;
    final distanceBetween = Geolocator.distanceBetween(
      prevPosition.latitude,
      prevPosition.longitude,
      position.latitude,
      position.longitude,
    );

    // 변하는 위치에 맞춰 카메라 이동
    // 일시중지 된 경우 이동하지 않음
    if (_timer!.isActive) {
      _updateCameraPosition(position);
    }

    // 변위가 15m 미만이면 상태 값 업데이트 하지 않음
    if (distanceBetween < 15.0) {
      return;
    }

    // 일시중지 되지 않은 경우에만 거리 값 업데이트
    if (_timer!.isActive) {
      nexttotalTravelDistance += distanceBetween / 1000;
    }

    // 일시중지 여부와 상관없이
    // 변위가 15m 이상일 때
    // 경로는 계속 추적, 기록
    _minLat = min(_minLat, position.latitude);
    _maxLat = max(_maxLat, position.latitude);
    _minLng = min(_minLng, position.longitude);
    _maxLng = max(_maxLng, position.longitude);

    _latlngList.add([position.latitude, position.longitude]);
    nextpolylineCoordinates.add(
      curLatLng,
    );

    state = prevState.copywith(
      curPosition: position,
      polylineCoordinates: nextpolylineCoordinates,
      totalTravelDistance: nexttotalTravelDistance,
    );
  }
}
