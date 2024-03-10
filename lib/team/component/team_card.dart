import 'package:b612_project_team3/team/model/team_model.dart';
import 'package:flutter/material.dart';

class TeamCard extends StatelessWidget {
  final TeamModel teamModel;

  const TeamCard({
    super.key,
    required this.teamModel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        children: [
          Text(teamModel.name),
          Text(teamModel.comment),
          Text(teamModel.address),
          Text(teamModel.createdAt),
          Text(teamModel.kind),
        ],
      ),
    );
  }
}
