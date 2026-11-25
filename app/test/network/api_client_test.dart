// ApiClient: iOS가 백그라운드에서 끊어 둔 연결로 첫 요청이 실패하면, GET은 새 연결로 한 번만 다시 보낸다.
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:partstock/core/network/api_client.dart';
import 'package:partstock/core/network/app_failure.dart';

void main() {
  test('끊긴 연결로 첫 GET이 실패하면 한 번 다시 보내 받는다', () async {
    var calls = 0;
    final api = ApiClient(
      MockClient((_) async {
        calls++;
        if (calls == 1) throw http.ClientException('Connection closed before full header was received');
        return http.Response('{"ok":true}', 200);
      }),
      'https://api.test',
    );

    expect(await api.get('/api/board', {'category': 'GPU'}), {'ok': true});
    expect(calls, 2);
  });

  test('다시 보내도 실패하면 연결 실패로 알린다(두 번까지만)', () async {
    var calls = 0;
    final api = ApiClient(
      MockClient((_) async {
        calls++;
        throw http.ClientException('no route');
      }),
      'https://api.test',
    );

    await expectLater(api.get('/api/board', {}), throwsA(isA<NetworkFailure>()));
    expect(calls, 2);
  });

  test('POST는 다시 보내지 않는다(알림이 두 번 걸리지 않게)', () async {
    var calls = 0;
    final api = ApiClient(
      MockClient((_) async {
        calls++;
        throw http.ClientException('Connection reset by peer');
      }),
      'https://api.test',
    );

    await expectLater(api.send('POST', '/api/alerts', body: {'a': 1}), throwsA(isA<NetworkFailure>()));
    expect(calls, 1);
  });
}
