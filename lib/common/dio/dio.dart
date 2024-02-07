import 'package:b612_project_team3/common/const/data.dart';
import 'package:b612_project_team3/common/secure_storage/secure_storage.dart';
import 'package:b612_project_team3/user/provider/auth_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();

  final storage = ref.watch(secureStorageProvider);

  dio.interceptors.add(
    CustomIntercepter(
      storage: storage,
      ref: ref,
    ),
  );

  return dio;
});

class CustomIntercepter extends Interceptor {
  final FlutterSecureStorage storage;
  final Ref ref;

  CustomIntercepter({
    required this.storage,
    required this.ref,
  });

  // 1) 요청을 보낼때
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    print('[REQ] [${options.method}] ${options.uri}');

    if (options.headers['accessToken'] == 'true') {
      options.headers.remove('accessToken');

      final token = await storage.read(key: ACCESS_TOKEN_KEY);

      options.headers.addAll(
        {'accessToken': token},
      );

      if (options.headers['refreshToken'] == 'true') {
        options.headers.remove('refreshToken');

        final token = await storage.read(key: REFRESH_TOKEN_KEY);

        options.headers.addAll(
          {'refreshToken': token},
        );
      }
    }

    return super.onRequest(options, handler);
  }

  // 2) 응답을 받을때
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    print(
        '[RES] [${response.requestOptions.method}] ${response.requestOptions.uri}');

    try {
      final accessToken = response.headers['accessToken']?[0].split(' ')[1];
      final refreshToken = response.headers['refreshToken']?[0].split(' ')[1];

      if (accessToken != null) {
        print('엑세스 토큰 : $accessToken');
        await storage.write(key: ACCESS_TOKEN_KEY, value: accessToken);
      }
      if (refreshToken != null) {
        print('리프레시 토큰 : $refreshToken');
        await storage.write(key: REFRESH_TOKEN_KEY, value: refreshToken);
      }
    } catch (e) {
      print('토큰 갱신 실패');
    }

    return super.onResponse(response, handler);
  }

  // 3) 에러가 났을때
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    print('[ERR] [${err.requestOptions.method}] ${err.requestOptions.uri}');

    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);

    // refreshToken 아예 없으면
    // 당연히 에러를 던진다
    if (refreshToken == null) {
      // 에러를 던질때는 handler.reject를 사용한다.
      return handler.reject(err);
    }

    // accessToken으로 시도했는데 오류가 발생한 경우
    // refreshToken으로 다시시도 한다.
    if (err.requestOptions.headers['accessToken'] != null) {
      final dio = Dio();

      try {
        final options = err.requestOptions;

        // accessToken을 지우고 refreshToken으로 재시도
        options.headers.remove('accessToken');
        options.headers.addAll(
          {'refreshToken': refreshToken},
        );

        // 요청 재전송
        final response = await dio.fetch(options);

        // refreshToken으로 재요청한 후, 정상적으로 응답이 오면
        // 응답 헤더에 담긴 토큰으로 토큰 최신화하기
        try {
          final newaccessToken =
              response.headers['accessToken']?[0].split(' ')[1];
          final newrefreshToken =
              response.headers['refreshToken']?[0].split(' ')[1];

          if (newaccessToken != null) {
            print('새 엑세스 토큰 : $newaccessToken');
            await storage.write(key: ACCESS_TOKEN_KEY, value: newaccessToken);
          }
          if (newrefreshToken != null) {
            print('새 리프레시 토큰 : $newrefreshToken');
            await storage.write(key: REFRESH_TOKEN_KEY, value: newrefreshToken);
          }
        } catch (e) {
          print('토큰 갱신 실패');
        }

        return handler.resolve(response);
      } on DioException catch (e) {
        ref.read(authProvider.notifier).logout();

        return handler.reject(e);
      }
    }

    return handler.reject(err);
  }
}
