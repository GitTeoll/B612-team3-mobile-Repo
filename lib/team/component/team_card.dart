import 'package:b612_project_team3/team/model/team_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TeamCard extends ConsumerWidget {
  final TeamModel teamModel;
  final void Function()? onTap;

  const TeamCard({
    super.key,
    required this.teamModel,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('팀 이름 : ${teamModel.name}'),
                  Text('주 활동 지역 : ${teamModel.address}'),
                ],
              ),
              Text(teamModel.kind == 'HOBBY' ? '취미반' : '전문반'),
            ],
          ),
        ),
      ),
    );
  }
}
