import 'package:b612_project_team3/navigation/component/action_button.dart';
import 'package:b612_project_team3/record/model/record_model.dart';
import 'package:b612_project_team3/record/provider/current_record_model_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class NavigationControllerWhenStopped extends StatelessWidget {
  final WidgetRef ref;
  final CurrentRecordModel currentRecordModel;
  final double size;

  const NavigationControllerWhenStopped({
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ActionButton(
                size: size,
                content: '끝내기',
                ontap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      final totalTravelDistance =
                          currentRecordModel.totalTravelDistance;

                      return AlertDialog(
                        content: Text(totalTravelDistance >= 1.0
                            ? '주행을 종료하시겠습니까?'
                            : '주행거리가 1km 미만인 경우 저장되지 않습니다.\n주행을 종료하시겠습니까?'),
                        actions: [
                          ElevatedButton(
                            onPressed: () async {
                              await ref
                                  .read(currentRecordModelProvider.notifier)
                                  .stopPositionTracking();

                              if (totalTravelDistance >= 1.0) {
                                context.go('/drivedone');
                              } else {
                                context.go('/');
                              }
                            },
                            child: const Text("예"),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              context.pop();
                            },
                            child: const Text("아니요"),
                          ),
                        ],
                      );
                    },
                  );
                },
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
                content: '계속',
                ontap: () {
                  ref.read(currentRecordModelProvider.notifier).startTimer();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
