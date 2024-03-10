import 'package:b612_project_team3/common/component/register_text_form_field.dart';
import 'package:b612_project_team3/common/const/colors.dart';
import 'package:b612_project_team3/common/layout/default_layout.dart';
import 'package:b612_project_team3/common/view/address_searching_screen.dart';
import 'package:b612_project_team3/navigation/component/action_button.dart';
import 'package:b612_project_team3/user/model/user_model.dart';
import 'package:b612_project_team3/user/provider/user_info_provider.dart';
import 'package:daum_postcode_search/data_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  static String get routeName => 'register';

  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  DataModel? _daumPostcodeSearchDataModel;
  final zoneCodeController = TextEditingController();
  final addressController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String userName = '';
  String sido = '';
  String sigungu = '';
  int? age;
  String gender = 'MALE';

  void tryValidation() async {
    final isValid = formKey.currentState!.validate();
    if (isValid) {
      formKey.currentState!.save();
      if (await ref.read(userInfoProvider.notifier).editInfo(
            UserModel(
              name: userName,
              address: '$sido $sigungu',
              age: age,
              gender: gender,
            ),
          )) {
        print('유저정보 등록 성공');
      } else {
        print('에러발생 : 유저정보 등록 실패');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '회원가입',
      child: SingleChildScrollView(
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
                    const Text('닉네임'),
                    const SizedBox(
                      height: 8.0,
                    ),
                    RegisterTextFormField(
                      valueKey: const ValueKey(1),
                      validator: (value) {
                        if (value!.isEmpty || value.length < 3) {
                          return '최소 3글자 이상 입력해주세요.';
                        }
                        if (RegExp('[가-힣a-zA-Z0-9]').allMatches(value).length !=
                            value.length) {
                          return '닉네임은 완성형한글, 영어, 숫자만 허용됩니다.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        userName = value!;
                      },
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(16),
                      ],
                      hintText: '닉네임',
                    ),
                    const SizedBox(
                      height: 16.0,
                    ),
                    const Text('나이'),
                    const SizedBox(
                      height: 8.0,
                    ),
                    RegisterTextFormField(
                      valueKey: const ValueKey(2),
                      validator: (value) {
                        if (value!.isEmpty || int.parse(value) <= 0) {
                          return '올바른 값을 입력해주세요.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        age = int.parse(value!);
                      },
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(3),
                      ],
                      hintText: '나이',
                    ),
                    const SizedBox(
                      height: 16.0,
                    ),
                    const Text('주소'),
                    const SizedBox(
                      height: 8.0,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 150,
                          child: RegisterTextFormField(
                            readOnly: true,
                            valueKey: const ValueKey(3),
                            validator: (value) {
                              return null;
                            },
                            onSaved: (value) {},
                            filled: true,
                            textEditingController: zoneCodeController,
                          ),
                        ),
                        const SizedBox(
                          width: 16.0,
                        ),
                        ElevatedButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: PRIMARY_COLOR,
                            foregroundColor: Colors.black,
                          ),
                          onPressed: () async {
                            try {
                              DataModel model =
                                  await Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const AddressSearchingScreen(),
                                ),
                              );

                              _daumPostcodeSearchDataModel = model;
                              addressController.text =
                                  _daumPostcodeSearchDataModel!.address;
                              zoneCodeController.text =
                                  _daumPostcodeSearchDataModel!.zonecode;
                              setState(() {});
                            } catch (error) {
                              print('주소찾기 실패');
                            }
                          },
                          child: const Text('주소찾기'),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 16.0,
                    ),
                    RegisterTextFormField(
                      readOnly: true,
                      valueKey: const ValueKey(4),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return '주소를 입력해주세요.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        sido = _daumPostcodeSearchDataModel!.sido;
                        sigungu = _daumPostcodeSearchDataModel!.sigungu;
                      },
                      filled: true,
                      textEditingController: addressController,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 16.0,
              ),
              const Text('성별'),
              Row(
                children: [
                  Radio(
                    value: 'MALE',
                    groupValue: gender,
                    onChanged: (value) {
                      setState(() {
                        gender = value!;
                      });
                    },
                  ),
                  const Text('남자'),
                  const SizedBox(
                    width: 16.0,
                  ),
                  Radio(
                    value: 'FEMALE',
                    groupValue: gender,
                    onChanged: (value) {
                      setState(() {
                        gender = value!;
                      });
                    },
                  ),
                  const Text('여자'),
                ],
              ),
              const SizedBox(
                height: 24.0,
              ),
              Center(
                child: ActionButton(
                  size: 100,
                  content: '가입',
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
