import 'package:b612_project_team3/record/model/record_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final driveDoneRecordModelProvider = StateNotifierProvider.autoDispose<
    DriveDoneRecordModelStateNotifier, RecordModelBase>(
  (ref) {
    ref.onDispose(
      () {
        print('드라이브던삭제');
      },
    );
    return DriveDoneRecordModelStateNotifier();
  },
);

class DriveDoneRecordModelStateNotifier extends StateNotifier<RecordModelBase> {
  DriveDoneRecordModelStateNotifier() : super(RecordModelLoading());

  void completeDrive(DriveDoneRecordModel driveDoneRecordModel) {
    state = driveDoneRecordModel;
  }

  void saveRecord() {}
}
