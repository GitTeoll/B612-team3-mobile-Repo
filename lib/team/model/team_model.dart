import 'package:json_annotation/json_annotation.dart';

part 'team_model.g.dart';

abstract class TeamModelBase {}

class TeamModelError extends TeamModelBase {
  final String message;

  TeamModelError({
    required this.message,
  });
}

class TeamModelLoading extends TeamModelBase {}

@JsonSerializable()
class TeamModel extends TeamModelBase {
  final String name;
  final String comment;
  final String address;
  final String createdAt;
  final String kind;

  TeamModel({
    required this.name,
    required this.comment,
    required this.address,
    required this.createdAt,
    required this.kind,
  });

  factory TeamModel.fromJson(Map<String, dynamic> json) =>
      _$TeamModelFromJson(json);

  Map<String, dynamic> toJson() => _$TeamModelToJson(this);
}

@JsonSerializable()
class TeamDetailModel extends TeamModel {
  final int count;

  TeamDetailModel({
    required super.name,
    required super.comment,
    required super.address,
    required super.createdAt,
    required super.kind,
    required this.count,
  });

  factory TeamDetailModel.fromJson(Map<String, dynamic> json) =>
      _$TeamDetailModelFromJson(json);
}

@JsonSerializable()
class JoinTeamModel extends TeamModelBase {
  final String name;
  final String joinedAt;

  JoinTeamModel({
    required this.name,
    required this.joinedAt,
  });

  Map<String, dynamic> toJson() => _$JoinTeamModelToJson(this);
}
