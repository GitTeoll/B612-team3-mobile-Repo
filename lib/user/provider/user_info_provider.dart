import 'package:b612_project_team3/common/const/data.dart';
import 'package:b612_project_team3/common/secure_storage/secure_storage.dart';
import 'package:b612_project_team3/firebase/service/auth_service.dart';
import 'package:b612_project_team3/user/model/user_model.dart';
import 'package:b612_project_team3/user/repository/auth_repository.dart';
import 'package:b612_project_team3/user/repository/user_info_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final userInfoProvider =
    StateNotifierProvider<UserInfoStateNotifier, UserModelBase?>(
  (ref) {
    final authRepository = ref.watch(authRepositoryProvider);
    final userInfoRepository = ref.watch(userInfoRepositoryProvider);
    final storage = ref.watch(secureStorageProvider);

    return UserInfoStateNotifier(
      authRepository: authRepository,
      repository: userInfoRepository,
      storage: storage,
    );
  },
);

class UserInfoStateNotifier extends StateNotifier<UserModelBase?> {
  final AuthRepository authRepository;
  final UserInfoRepository repository;
  final FlutterSecureStorage storage;

  UserInfoStateNotifier({
    required this.authRepository,
    required this.repository,
    required this.storage,
  }) : super(UserModelLoading()) {
    getInfo();
  }

  Future<void> getInfo() async {
    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);
    final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);

    if (refreshToken == null || accessToken == null) {
      state = null;
      return;
    }

    final resp = await repository.getInfo();

    state = resp;
  }

  Future<bool> editInfo(UserModel userModel) async {
    final resp = await repository.editInfo(
      body: userModel,
    );

    if (userModel.address == resp.address &&
        userModel.age == resp.age &&
        userModel.gender == resp.gender &&
        userModel.name == resp.name) {
      state = resp;
      return true;
    } else {
      return false;
    }
  }

  Future<UserModelBase> login() async {
    try {
      state = UserModelLoading();

      final resp = await authRepository.login();

      if (resp == null) {
        throw Exception();
      }

      await storage.write(key: REFRESH_TOKEN_KEY, value: resp.refreshToken);
      await storage.write(key: ACCESS_TOKEN_KEY, value: resp.accessToken);

      final userResp = await repository.getInfo();
      //firebase 로그인
      firebaseAuthService().firebaseLogin(userResp.name);
      state = userResp;

      return userResp;
    } catch (e) {
      state = UserModelError(message: '로그인에 실패했습니다.');

      return Future.value(state);
    }
  }

  Future<void> logout() async {
    state = null;

    await Future.wait(
      [
        storage.delete(key: REFRESH_TOKEN_KEY),
        storage.delete(key: ACCESS_TOKEN_KEY),
      ],
    );
  }
}
