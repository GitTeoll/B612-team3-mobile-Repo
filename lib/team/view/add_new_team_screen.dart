import 'package:b612_project_team3/common/component/register_text_form_field.dart';
import 'package:b612_project_team3/common/layout/default_layout.dart';
import 'package:b612_project_team3/navigation/component/action_button.dart';
import 'package:b612_project_team3/team/model/team_model.dart';
import 'package:b612_project_team3/team/provider/team_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AddNewTeamScreen extends ConsumerStatefulWidget {
  static String get routeName => 'addnewteam';

  const AddNewTeamScreen({super.key});

  @override
  ConsumerState<AddNewTeamScreen> createState() => _AddNewTeamScreenState();
}

class _AddNewTeamScreenState extends ConsumerState<AddNewTeamScreen> {
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  String teamName = '';
  String description = '';
  String address = '';
  String kind = 'HOBBY';

  void tryValidation() async {
    final isValid = formKey.currentState!.validate();
    if (isValid) {
      formKey.currentState!.save();

      setState(() {
        isLoading = true;
      });

      if (await ref.read(teamProvider.notifier).addNewTeam(
            TeamModel(
              name: teamName,
              comment: description,
              address: address,
              createdAt: DateTime.now().toIso8601String(),
              kind: kind,
            ),
          )) {
        context.pop();
      } else {
        print('팀 생성 실패');
        setState(() {
          isLoading = false;
        });
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            content: const Text('팀 생성에 실패했습니다.\n다시 시도해주세요.'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  context.pop();
                },
                child: const Text('확인'),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '새 팀 등록',
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('팀 이름'),
                          const SizedBox(
                            height: 8.0,
                          ),
                          RegisterTextFormField(
                            valueKey: const ValueKey(1),
                            validator: (value) {
                              if (value!.isEmpty || value.length < 2) {
                                return '최소 2글자 이상 입력해주세요.';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              teamName = value!;
                            },
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(30),
                            ],
                            hintText: '팀 이름',
                            initialValue: teamName == '' ? null : teamName,
                          ),
                          const SizedBox(
                            height: 16.0,
                          ),
                          const Text('팀 설명'),
                          const SizedBox(
                            height: 8.0,
                          ),
                          RegisterTextFormField(
                            valueKey: const ValueKey(2),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return '팀 설명을 입력해주세요.';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              description = value!;
                            },
                            maxLines: 4,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(100),
                            ],
                            hintText: '팀 설명',
                            initialValue:
                                description == '' ? null : description,
                          ),
                          const SizedBox(
                            height: 16.0,
                          ),
                          const Text('주 활동 지역'),
                          const SizedBox(
                            height: 8.0,
                          ),
                          RegisterTextFormField(
                            valueKey: const ValueKey(3),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return '주 활동 지역을 입력해주세요.';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              address = value!;
                            },
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(30),
                            ],
                            hintText: '주 활동 지역',
                            initialValue: address == '' ? null : address,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 16.0,
                    ),
                    const Text('팀 종류'),
                    Row(
                      children: [
                        Radio(
                          value: 'HOBBY',
                          groupValue: kind,
                          onChanged: (value) {
                            setState(() {
                              kind = value!;
                            });
                          },
                        ),
                        const Text('취미반'),
                        const SizedBox(
                          width: 16.0,
                        ),
                        Radio(
                          value: 'PROFESSIONAL',
                          groupValue: kind,
                          onChanged: (value) {
                            setState(() {
                              kind = value!;
                            });
                          },
                        ),
                        const Text('전문반'),
                      ],
                    ),
                    const SizedBox(
                      height: 24.0,
                    ),
                    Center(
                      child: ActionButton(
                        size: 100,
                        content: '등록',
                        ontap: () {
                          tryValidation();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
