import 'dart:async';
import 'dart:math';

import 'package:b612_project_team3/common/utils/data_utils.dart';
import 'package:b612_project_team3/record/model/record_model.dart';
import 'package:b612_project_team3/record/provider/drive_done_record_model_provider.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_polyline_algorithm/google_polyline_algorithm.dart';
import 'package:uuid/uuid.dart';
import 'package:wakelock/wakelock.dart';

final currentRecordModelProvider = StateNotifierProvider.autoDispose<
    CurrentRecordModelStateNotifier, RecordModelBase>(
  (ref) => CurrentRecordModelStateNotifier(ref),
);

class CurrentRecordModelStateNotifier extends StateNotifier<RecordModelBase> {
  final Ref _ref;
  StreamSubscription<Position>? _positionStreamSubscription;
  Timer? _timer;
  late DateTime _startTime;
  late DateTime _endTime;
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
    Wakelock.enable();

    initialBearing = (await FlutterCompass.events?.first)?.heading;

    _positionStreamSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(distanceFilter: 10),
    ).listen(_positionListener);
  }

  void startCameraTracking(GoogleMapController controller) {
    googleMapController = controller;
  }

  LatLngBounds getLatLngBounds() {
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
      final bearing = (await FlutterCompass.events?.first)?.heading;

      googleMapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(
              prevState.curPosition.latitude,
              prevState.curPosition.longitude,
            ),
            zoom: 16,
            bearing: bearing ?? 0.0,
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
        CameraUpdate.newLatLngBounds(getLatLngBounds(), 80),
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
    _endTime = DateTime.now();

    await googleMapController!.moveCamera(
      CameraUpdate.newLatLngBounds(getLatLngBounds(), 80),
    );

    final driveDoneState = state as CurrentRecordModel;

    const uuid = Uuid();

    _ref.read(driveDoneRecordModelProvider.notifier).completeDrive(
          DriveDoneRecordModel(
            id: uuid.v4(),
            startTime: _startTime.toIso8601String(),
            endTime: _endTime.toIso8601String(),
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
            zoom: DataUtils.decimalPointFix(
                await googleMapController!.getZoomLevel(), 6),
          ),
        );

    Wakelock.disable();
  }

  void _updateCameraPosition(Position position) async {
    if (googleMapController != null) {
      final zoom = await googleMapController!.getZoomLevel();
      final bearing = (await FlutterCompass.events?.first)?.heading;

      googleMapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(
              position.latitude,
              position.longitude,
            ),
            zoom: zoom,
            bearing: bearing ?? 0.0,
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

      _startTime = DateTime.now();

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

    // 변하는 위치에 맞춰 카메라 이동 및 거리 갱신
    // 일시중지 된 경우 카메라 추적 및 거리 갱신 하지않음
    if (_timer!.isActive) {
      _updateCameraPosition(position);

      nexttotalTravelDistance += Geolocator.distanceBetween(
            prevPosition.latitude,
            prevPosition.longitude,
            position.latitude,
            position.longitude,
          ) /
          1000;
    }

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
