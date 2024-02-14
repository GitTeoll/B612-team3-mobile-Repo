import 'package:b612_project_team3/common/const/data.dart';
import 'package:b612_project_team3/common/dio/dio.dart';
import 'package:b612_project_team3/common/model/login_response.dart';
import 'package:b612_project_team3/firebase/firebase_auth_remote_data_source.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dio = ref.watch(dioProvider);

  return AuthRepository(baseUrl: 'http://$ip', dio: dio);
});

class AuthRepository {
  // http://$ip
  final String baseUrl;
  final Dio dio;

  AuthRepository({
    required this.baseUrl,
    required this.dio,
  });

  final _firebaseAuthDataSource = FirebaseAuthRemoteDataSource();

  Future<LoginResponse?> login() async {
    // 카카오톡 실행 가능 여부 확인
    // 카카오톡 실행이 가능하면 카카오톡으로 로그인, 아니면 카카오계정으로 로그인
    if (await isKakaoTalkInstalled()) {
      try {
        await UserApi.instance.loginWithKakaoTalk();
        print('카카오톡으로 로그인 성공');
      } catch (error) {
        print('카카오톡으로 로그인 실패 $error');

        // 사용자가 카카오톡 설치 후 디바이스 권한 요청 화면에서 로그인을 취소한 경우,
        // 의도적인 로그인 취소로 보고 카카오계정으로 로그인 시도 없이 로그인 취소로 처리 (예: 뒤로 가기)
        if (error is PlatformException && error.code == 'CANCELED') {
          return null;
        }
        // 카카오톡에 연결된 카카오계정이 없는 경우, 카카오계정으로 로그인
        try {
          await UserApi.instance.loginWithKakaoAccount();
          print('카카오계정으로 로그인 성공');
        } catch (error) {
          print('카카오계정으로 로그인 실패 $error');
          return null;
        }
      }
    } else {
      try {
        await UserApi.instance.loginWithKakaoAccount();
        print('카카오계정으로 로그인 성공');
      } catch (error) {
        print('카카오계정으로 로그인 실패 $error');
        return null;
      }
    }

    final user = await UserApi.instance.me();
    final id = user.id;

    final resp = await dio.post(
      '$baseUrl/user/mobile/kakao',
      data: {"id": "$id"},
    );
    //firebase token으로 로그인 진행
    final token = await _firebaseAuthDataSource.createCustomToken({
      'uid': user.id.toString(),
      // 'displayName': user!.kakaoAccount!.profile!.nickname,
      // 'email': user!.kakaoAccount!.email!,
      // 'photoURL': user!.kakaoAccount!.profile!.profileImageUrl!,
    });

    await FirebaseAuth.instance.signInWithCustomToken(token);

    return LoginResponse.fromJson(
      resp.data,
    );
  }
}
