// 목표가 알림 서버 호출. 기기 토큰이 곧 사용자라 X-Device-Token 머리글로 보낸다.
import 'package:injectable/injectable.dart';

import '../../../core/network/api_client.dart';
import 'alert_models.dart';

@lazySingleton
class AlertsRepository {
  AlertsRepository(this._api);

  final ApiClient _api;

  Map<String, String> _auth(String token) => {'X-Device-Token': token};

  Future<void> registerDevice(String token, {required String platform, required String locale}) =>
      _api.send('POST', '/api/devices', body: {'token': token, 'platform': platform, 'locale': locale});

  Future<List<PriceAlert>> list(String token) async {
    final json = await _api.send('GET', '/api/alerts', headers: _auth(token)) as List;
    return json.cast<Map<String, dynamic>>().map(PriceAlert.fromMap).toList();
  }

  Future<PriceAlert> create(String token, String tickerKey, AlertDirection direction, int targetCents) async {
    final json = await _api.send(
      'POST',
      '/api/alerts',
      headers: _auth(token),
      body: {'tickerKey': tickerKey, 'direction': direction.code, 'targetCents': targetCents},
    );
    return PriceAlert.fromMap(json as Map<String, dynamic>);
  }

  Future<void> delete(String token, int id) => _api.send('DELETE', '/api/alerts/$id', headers: _auth(token));
}
