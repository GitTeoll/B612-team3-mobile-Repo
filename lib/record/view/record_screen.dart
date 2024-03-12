import 'package:b612_project_team3/record/model/record_model.dart';
import 'package:b612_project_team3/record/provider/drive_done_record_model_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/driving_records.dart';
import '../widgets/recent_drive_widget.dart';

class RecordScreen extends ConsumerWidget {
  const RecordScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final driveDoneRecordModel = ref.watch(driveDoneRecordModelProvider);

    return driveDoneRecordModel is RecordModelLoading
        ? const Center(
            child: Text('최근 주행 기록이 없습니다.\n주행을 시작해주세요.'),
          )
        : SingleChildScrollView(
            child: Column(
              children: [
                RecentDriveWidget(
                  driveDoneRecordModel:
                      driveDoneRecordModel as DriveDoneRecordModel,
                ),
                // SizedBox(
                //   width: MediaQuery.of(context).size.width * 0.9,
                //   height: MediaQuery.of(context).size.height * 0.02,
                // ),
                // SizedBox(
                //   width: MediaQuery.of(context).size.width * 0.9,
                //   child: const Text(
                //     "Driving Records",
                //     style: TextStyle(
                //       fontSize: 20,
                //     ),
                //   ),
                // ),
                // SizedBox(
                //   height: MediaQuery.of(context).size.height * 0.015,
                // ),
                // SizedBox(
                //   width: MediaQuery.of(context).size.width * 0.05,
                // ),
                // Row(
                //   children: [
                //     SizedBox(
                //       width: MediaQuery.of(context).size.width * 0.05,
                //     ),
                //     SizedBox(
                //       width: MediaQuery.of(context).size.width * 0.95,
                //       height: MediaQuery.of(context).size.height * 0.28,
                //       child: ListView(
                //         scrollDirection: Axis.horizontal,
                //         children: <Widget>[
                //           const DrivingRecordsCard(),
                //           SizedBox(
                //             width: MediaQuery.of(context).size.width * 0.07,
                //           ),
                //           const DrivingRecordsCard(),
                //           SizedBox(
                //             width: MediaQuery.of(context).size.width * 0.07,
                //           ),
                //           const DrivingRecordsCard(),
                //         ],
                //       ),
                //     ),
                //   ],
                // )
              ],
            ),
          );
  }
}
