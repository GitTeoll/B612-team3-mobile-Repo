import 'package:b612_project_team3/record/model/record_model.dart';
import 'package:b612_project_team3/record/repository/record_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final driveDoneRecordModelProvider = StateNotifierProvider.autoDispose<
    DriveDoneRecordModelStateNotifier, RecordModelBase>(
  (ref) {
    final recordRepository = ref.watch(recordRepositoryProvider);

    return DriveDoneRecordModelStateNotifier(
      recordRepository: recordRepository,
    );
  },
);

class DriveDoneRecordModelStateNotifier extends StateNotifier<RecordModelBase> {
  final RecordRepository recordRepository;

  DriveDoneRecordModelStateNotifier({
    required this.recordRepository,
  }) : super(RecordModelLoading());

  void completeDrive(DriveDoneRecordModel driveDoneRecordModel) {
    state = driveDoneRecordModel;
  }

  Future<bool> saveRecord() async {
    if (state is! DriveDoneRecordModel) {
      return false;
    }

    try {
      await recordRepository.saveRecord(body: state as DriveDoneRecordModel);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
