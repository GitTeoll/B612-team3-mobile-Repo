import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'record_model.g.dart';

abstract class RecordModelBase {}

class RecordModelLoading extends RecordModelBase {}

class RecordModelError extends RecordModelBase {
  final String message;

  RecordModelError({
    required this.message,
  });
}

class CurrentRecordModel extends RecordModelBase {
  final Position curPosition;
  final List<LatLng> polylineCoordinates;
  final int elapsedTime; // sec
  final double totalTravelDistance; // km
  final bool isStopped;

  CurrentRecordModel({
    required this.curPosition,
    required this.polylineCoordinates,
    this.totalTravelDistance = 0,
    this.elapsedTime = 0,
    this.isStopped = false,
  });

  CurrentRecordModel copywith({
    Position? curPosition,
    List<LatLng>? polylineCoordinates,
    int? elapsedTime,
    double? totalTravelDistance,
    bool? isStopped,
  }) {
    return CurrentRecordModel(
      curPosition: curPosition ?? this.curPosition,
      polylineCoordinates: polylineCoordinates ?? this.polylineCoordinates,
      elapsedTime: elapsedTime ?? this.elapsedTime,
      totalTravelDistance: totalTravelDistance ?? this.totalTravelDistance,
      isStopped: isStopped ?? this.isStopped,
    );
  }
}

@JsonSerializable()
class DriveDoneRecordModel extends RecordModelBase {
  final String id;
  final String startTime;
  final String endTime;
  final int elapsedTime; // sec
  final double totalTravelDistance; // km
  final String encodedPolyline;
  final List<double> startLatLng;
  final List<double> endLatLng;
  final List<double> centerLatLng;
  final double zoom;
  String name = "";
  int rating = 3;
  int difficulty = 3;
  String review = "";
  bool public = false;

  DriveDoneRecordModel({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.elapsedTime,
    required this.totalTravelDistance,
    required this.encodedPolyline,
    required this.startLatLng,
    required this.endLatLng,
    required this.centerLatLng,
    required this.zoom,
  });

  Map<String, dynamic> toJson() => _$DriveDoneRecordModelToJson(this);
}
