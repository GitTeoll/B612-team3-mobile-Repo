import 'dart:math';

import 'package:b612_project_team3/navigation/component/navigation_controller_when_not_stopped.dart';
import 'package:b612_project_team3/navigation/component/navigation_controller_when_stopped.dart';
import 'package:b612_project_team3/record/model/record_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NavigationController extends StatelessWidget {
  final WidgetRef ref;
  final CurrentRecordModel currentRecordModel;

  const NavigationController({
    super.key,
    required this.ref,
    required this.currentRecordModel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(46.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 36.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final size = min(constraints.maxHeight, constraints.maxWidth);
            return currentRecordModel.isStopped
                ? NavigationControllerWhenStopped(
                    ref: ref,
                    currentRecordModel: currentRecordModel,
                    size: size,
                  )
                : NavigationControllerWhenNotStopped(
                    ref: ref,
                    currentRecordModel: currentRecordModel,
                    size: size,
                  );
          },
        ),
      ),
    );
  }
}
