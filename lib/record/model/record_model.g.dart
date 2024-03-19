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
      publicCourse: json['publicCourse'] as bool? ?? false,
      original: json['original'] as bool? ?? true,
    )
      ..name = json['name'] as String
      ..rating = json['rating'] as int
      ..difficulty = json['difficulty'] as int
      ..review = json['review'] as String;

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
      'original': instance.original,
    };

RecordModel _$RecordModelFromJson(Map<String, dynamic> json) => RecordModel(
      courseId: json['courseId'] as int,
      reviewCount: json['reviewCount'] as int,
      avgElapsedTime: json['avgElapsedTime'] as int,
      totalTravelDistance: (json['totalTravelDistance'] as num).toDouble(),
      zoom: (json['zoom'] as num).toDouble(),
      avgRating: (json['avgRating'] as num).toDouble(),
      avgDifficulty: (json['avgDifficulty'] as num).toDouble(),
      publicCourse: json['publicCourse'] as bool,
      original: json['original'] as bool,
      name: json['name'] as String,
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
    );

Map<String, dynamic> _$RecordModelToJson(RecordModel instance) =>
    <String, dynamic>{
      'courseId': instance.courseId,
      'reviewCount': instance.reviewCount,
      'avgElapsedTime': instance.avgElapsedTime,
      'totalTravelDistance': instance.totalTravelDistance,
      'zoom': instance.zoom,
      'avgRating': instance.avgRating,
      'avgDifficulty': instance.avgDifficulty,
      'publicCourse': instance.publicCourse,
      'original': instance.original,
      'name': instance.name,
      'startLatLng': instance.startLatLng,
      'endLatLng': instance.endLatLng,
      'centerLatLng': instance.centerLatLng,
      'southwestLatLng': instance.southwestLatLng,
      'northeastLatLng': instance.northeastLatLng,
    };
