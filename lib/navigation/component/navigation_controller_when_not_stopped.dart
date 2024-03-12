import 'dart:ui';

import 'package:b612_project_team3/navigation/component/action_button.dart';
import 'package:b612_project_team3/record/model/record_model.dart';
import 'package:b612_project_team3/record/provider/current_record_model_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NavigationControllerWhenNotStopped extends StatelessWidget {
  final WidgetRef ref;
  final CurrentRecordModel currentRecordModel;
  final double size;

  const NavigationControllerWhenNotStopped({
    super.key,
    required this.ref,
    required this.currentRecordModel,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          flex: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currentRecordModel.elapsedTime == 0
                        ? '--'
                        : (currentRecordModel.totalTravelDistance /
                                currentRecordModel.elapsedTime *
                                3600)
                            .toStringAsFixed(1),
                    style: const TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.w600,
                      fontFeatures: [FontFeature.tabularFigures()],
                    ),
                  ),
                  const Text(
                    'speed',
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Text(
                    'km/h',
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Flexible(
          flex: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ActionButton(
                size: size,
                content: 'Stop!',
                ontap: () {
                  ref.read(currentRecordModelProvider.notifier).stopTimer();
                },
              ),
            ],
          ),
        ),
        const Flexible(
          flex: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'SOS',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
