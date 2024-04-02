import 'package:b612_project_team3/common/const/colors.dart';
import 'package:b612_project_team3/common/layout/default_layout.dart';
import 'package:b612_project_team3/common/utils/data_utils.dart';
import 'package:b612_project_team3/navigation/component/action_button.dart';
import 'package:b612_project_team3/record/model/record_model.dart';
import 'package:b612_project_team3/record/provider/drive_done_record_model_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class DriveDoneScreen extends ConsumerStatefulWidget {
  static String get routeName => 'drivedone';

  const DriveDoneScreen({
    super.key,
  });

  @override
  ConsumerState<DriveDoneScreen> createState() => _DriveDoneScreenState();
}

class _DriveDoneScreenState extends ConsumerState<DriveDoneScreen> {
  final outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(30.0),
    borderSide: const BorderSide(color: Colors.grey),
  );
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final driveDoneRecordModel =
        ref.watch(driveDoneRecordModelProvider) as DriveDoneRecordModel;

    return PopScope(
      canPop: false,
      onPopInvoked: (_) {
        _driveCancle(context);
      },
      child: DefaultLayout(
        title: 'Your Ride',
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextFormField(
                        initialValue: driveDoneRecordModel.name == ''
                            ? null
                            : driveDoneRecordModel.name,
                        decoration: InputDecoration(
                          hintText: '코스 이름',
                          hintStyle: const TextStyle(color: Colors.grey),
                          contentPadding: const EdgeInsets.all(16.0),
                          border: outlineInputBorder,
                          focusedBorder: outlineInputBorder,
                          enabledBorder: outlineInputBorder,
                        ),
                        onChanged: (value) {
                          driveDoneRecordModel.name = value;
                        },
                        onTapOutside: (_) {
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 24.0, left: 24.0, right: 24.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.7),
                              spreadRadius: 0,
                              blurRadius: 5.0,
                              offset: const Offset(2, 4),
                            ),
                          ],
                        ),
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 24.0,
                            horizontal: 24.0,
                          ),
                          child: Column(
                            children: [
                              CustomContainer(
                                content: DataUtils.secToHHMMSS(
                                  driveDoneRecordModel.elapsedTime,
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              CustomContainer(
                                content:
                                    '${driveDoneRecordModel.totalTravelDistance.toStringAsFixed(2)}km',
                              ),
                              const SizedBox(height: 16.0),
                              const Text('별점'),
                              RatingBar(
                                glow: false,
                                minRating: 1,
                                initialRating:
                                    driveDoneRecordModel.rating.toDouble(),
                                direction: Axis.horizontal,
                                allowHalfRating: false,
                                itemCount: 5,
                                ratingWidget: RatingWidget(
                                  full: const Icon(
                                    Icons.star,
                                    color: PRIMARY_COLOR,
                                  ),
                                  half: const Icon(
                                    Icons.star_half,
                                    color: PRIMARY_COLOR,
                                  ),
                                  empty: const Icon(
                                    Icons.star_outline,
                                    color: PRIMARY_COLOR,
                                  ),
                                ),
                                onRatingUpdate: (value) {
                                  driveDoneRecordModel.rating = value.toInt();
                                },
                              ),
                              const SizedBox(
                                height: 16.0,
                              ),
                              const Text('난이도'),
                              RatingBar(
                                glow: false,
                                minRating: 1,
                                initialRating:
                                    driveDoneRecordModel.difficulty.toDouble(),
                                direction: Axis.horizontal,
                                allowHalfRating: false,
                                itemCount: 5,
                                ratingWidget: RatingWidget(
                                  full: const Icon(
                                    Icons.circle,
                                    color: PRIMARY_COLOR,
                                  ),
                                  half: const Icon(
                                    Icons.circle,
                                    color: PRIMARY_COLOR,
                                  ),
                                  empty: const Icon(
                                    Icons.circle_outlined,
                                    color: PRIMARY_COLOR,
                                  ),
                                ),
                                onRatingUpdate: (value) {
                                  driveDoneRecordModel.difficulty =
                                      value.toInt();
                                },
                              ),
                              const SizedBox(
                                height: 16.0,
                              ),
                              TextFormField(
                                initialValue: driveDoneRecordModel.review == ''
                                    ? null
                                    : driveDoneRecordModel.review,
                                decoration: InputDecoration(
                                  hintText: '후기',
                                  hintStyle:
                                      const TextStyle(color: Colors.grey),
                                  contentPadding: const EdgeInsets.all(16.0),
                                  border: outlineInputBorder,
                                  focusedBorder: outlineInputBorder,
                                  enabledBorder: outlineInputBorder,
                                ),
                                maxLines: 4,
                                onChanged: (value) {
                                  driveDoneRecordModel.review = value;
                                },
                                onTapOutside: (_) {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                },
                              ),
                              const SizedBox(
                                height: 16.0,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  ActionButton(
                                    size: 100,
                                    content: '등록',
                                    ontap: () async {
                                      await showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (context) => AlertDialog(
                                          content: const Text(
                                              '주행코스를 다른 사용자에게 공개하시겠습니까?'),
                                          actions: [
                                            ElevatedButton(
                                              onPressed: () {
                                                driveDoneRecordModel
                                                    .publicCourse = true;
                                                context.pop();
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
                                        ),
                                      );

                                      setState(() {
                                        isLoading = true;
                                      });

                                      if (await ref
                                          .read(driveDoneRecordModelProvider
                                              .notifier)
                                          .saveRecord()) {
                                        context.go('/');
                                      } else {
                                        print('코스 저장 에러');
                                        setState(() {
                                          isLoading = false;
                                        });
                                        showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (context) => AlertDialog(
                                            content: const Text(
                                                '저장에 실패했습니다.\n다시 시도해주세요.'),
                                            actions: [
                                              ElevatedButton(
                                                onPressed: () {
                                                  context.pop();
                                                },
                                                child: const Text("확인"),
                                              ),
                                            ],
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                  ActionButton(
                                    size: 100,
                                    content: '등록 취소',
                                    ontap: () {
                                      _driveCancle(context);
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

Future<dynamic> _driveCancle(BuildContext context) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      content: const Text('등록을 취소하시겠습니까?'),
      actions: [
        ElevatedButton(
          onPressed: () {
            context.go('/');
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
    ),
  );
}

class CustomContainer extends StatelessWidget {
  final String content;

  const CustomContainer({
    super.key,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: PRIMARY_COLOR,
        borderRadius: BorderRadius.circular(16.0),
      ),
      width: 160,
      child: Center(
        child: Text(
          content,
          style: const TextStyle(
            fontSize: 24.0,
          ),
        ),
      ),
    );
  }
}
