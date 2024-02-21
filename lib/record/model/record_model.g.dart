// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DriveDoneRecordModel _$DriveDoneRecordModelFromJson(
        Map<String, dynamic> json) =>
    DriveDoneRecordModel(
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
      elapsedTime: json['elapsedTime'] as int,
      totalTravelDistance: (json['totalTravelDistance'] as num).toDouble(),
      encodedPolyline: json['encodedPolyline'] as String,
      startLatLng: (json['startLatLng'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
      endLatLng: (json['endLatLng'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
      centerLatLng: (json['centerLatLng'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
      southwestLatLng: (json['southwestLatLng'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
      northeastLatLng: (json['northeastLatLng'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
      zoom: (json['zoom'] as num).toDouble(),
    )
      ..name = json['name'] as String
      ..rating = json['rating'] as int
      ..difficulty = json['difficulty'] as int
      ..review = json['review'] as String
      ..publicCourse = json['publicCourse'] as bool;

Map<String, dynamic> _$DriveDoneRecordModelToJson(
        DriveDoneRecordModel instance) =>
    <String, dynamic>{
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'elapsedTime': instance.elapsedTime,
      'totalTravelDistance': instance.totalTravelDistance,
      'encodedPolyline': instance.encodedPolyline,
      'startLatLng': instance.startLatLng,
      'endLatLng': instance.endLatLng,
      'centerLatLng': instance.centerLatLng,
      'southwestLatLng': instance.southwestLatLng,
      'northeastLatLng': instance.northeastLatLng,
      'zoom': instance.zoom,
      'name': instance.name,
      'rating': instance.rating,
      'difficulty': instance.difficulty,
      'review': instance.review,
      'publicCourse': instance.publicCourse,
    };
