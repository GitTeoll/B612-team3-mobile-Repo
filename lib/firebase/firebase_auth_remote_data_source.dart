import 'package:http/http.dart' as http;
import 'dart:convert';

class FirebaseAuthRemoteDataSource {
  final String url =
      'https://us-central1-cycle-60fc2.cloudfunctions.net/createCustomToken';

  Future<String> createCustomToken(Map<String, dynamic> user) async {
    try {
      // Firebase Function 호출
      final customTokenResponse = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(user),
      );

      // HTTP 요청 성공 여부 확인
      if (customTokenResponse.statusCode == 200) {
        // 성공적으로 응답을 받았을 때
        print('성공: ${customTokenResponse.body}');
        return customTokenResponse.body; // 성공적으로 받은 응답 반환
      } else {
        // 서버 오류 또는 요청이 잘못된 경우
        print('서버 오류: ${customTokenResponse.statusCode}');
        return 'Error: Server returned ${customTokenResponse.statusCode}'; // 에러 메시지 반환
      }
    } catch (e) {
      // 네트워크 요청 중 오류 발생
      print('네트워크 요청 중 오류 발생: $e');
      return 'Error: Network request failed'; // 예외 처리 로직, 에러 메시지 반환
    }
  }
}
