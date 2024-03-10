// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TeamModel _$TeamModelFromJson(Map<String, dynamic> json) => TeamModel(
      name: json['name'] as String,
      comment: json['comment'] as String,
      address: json['address'] as String,
      createdAt: json['createdAt'] as String,
      kind: json['kind'] as String,
    );

Map<String, dynamic> _$TeamModelToJson(TeamModel instance) => <String, dynamic>{
      'name': instance.name,
      'comment': instance.comment,
      'address': instance.address,
      'createdAt': instance.createdAt,
      'kind': instance.kind,
    };

TeamDetailModel _$TeamDetailModelFromJson(Map<String, dynamic> json) =>
    TeamDetailModel(
      name: json['name'] as String,
      comment: json['comment'] as String,
      address: json['address'] as String,
      createdAt: json['createdAt'] as String,
      kind: json['kind'] as String,
      count: json['count'] as int,
    );

Map<String, dynamic> _$TeamDetailModelToJson(TeamDetailModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'comment': instance.comment,
      'address': instance.address,
      'createdAt': instance.createdAt,
      'kind': instance.kind,
      'count': instance.count,
    };

JoinTeamModel _$JoinTeamModelFromJson(Map<String, dynamic> json) =>
    JoinTeamModel(
      name: json['name'] as String,
      joinedAt: json['joinedAt'] as String,
    );

Map<String, dynamic> _$JoinTeamModelToJson(JoinTeamModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'joinedAt': instance.joinedAt,
    };
