import 'package:b612_project_team3/common/view/address_searching_screen.dart';
import 'package:b612_project_team3/firebase/firebase_auth_remote_data_source.dart';
import 'package:b612_project_team3/firebase/service/database_service.dart';
import 'package:b612_project_team3/user/model/user_model.dart';
import 'package:b612_project_team3/user/provider/user_info_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:dio/dio.dart';

class firebaseAuthService {
  final _firebaseAuthDataSource = FirebaseAuthRemoteDataSource();
  final Dio _dio = Dio();

  String email = 'null@null.com';

  Future firebaseLogin(
      String userName, String? gender, int? age, String? address) async {
    final user = await UserApi.instance.me();
    print("uid = ${user.id.toString()}");

    //firebase token으로 로그인 진행
    final token = await _firebaseAuthDataSource.createCustomToken({
      'uid': user.id.toString(),
      'userName': userName.toString(),
      'gender': gender.toString(),
      'age': age,
      'address': address.toString(),
      // 'displayName': user!.kakaoAccount!.profile!.nickname,
      // 'email': user!.kakaoAccount!.email!,
      // 'photoURL': user!.kakaoAccount!.profile!.profileImageUrl!,
    });

    print("token = $token");
    await FirebaseAuth.instance.signInWithCustomToken(token);

    await DatabaseService(uid: 'kakao:${user.id}')
        .updateUserData(userName, email);

    print('파이어베이스에서 카카오계정으로 로그인 성공');
  }

  // // 사용자 정보를 가져오는 메소드
  // Future<String> getUserName() async {
  //   String baseUrl = 'http://${dotenv.env['IP']}/user/info';
  //   try {
  //     final response = await _dio.get(baseUrl);
  //     if (response.statusCode == 200) {
  //       // 응답이 성공적인 경우, JSON 데이터에서 name 값을 추출
  //       final String name = response.data['name'];
  //       return name;
  //     } else {
  //       // 서버 에러 처리
  //       print('서버 에러: ${response.statusCode}');
  //       return 'error';
  //     }
  //   } catch (e) {
  //     // 요청 실패 또는 예외 처리
  //     print('요청 실패 또는 예외 발생: $e');
  //     return 'error';
  //   }
  // }
}
