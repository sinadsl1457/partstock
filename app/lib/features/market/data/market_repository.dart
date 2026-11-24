// 시세 읽기 저장소. 시세 목록·차트·관심 화면의 Cubit이 부른다.
// 시세 목록은 마지막 응답을 저장해 두었다가 앱을 켜자마자 먼저 보여 준다(그다음 새로 받음).
import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/network/api_client.dart';
import 'market_models.dart';

@lazySingleton
class MarketRepository {
  MarketRepository(this._api, this._prefs);

  final ApiClient _api;
  final SharedPreferences _prefs;

  static String _boardKey(Category c) => 'cache.board.${c.code}';

  Future<Board> board(Category category) async {
    final json = await _api.get('/api/board', {'category': category.code});
    await _prefs.setString(_boardKey(category), jsonEncode(json));
    return Board.fromMap(json);
  }

  /// 마지막으로 받은 시세 목록. 없거나 저장 모양이 깨졌으면 null.
  Board? cachedBoard(Category category) {
    final raw = _prefs.getString(_boardKey(category));
    if (raw == null) return null;
    try {
      return Board.fromMap(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  Future<Movers> movers() async => Movers.fromMap(await _api.get('/api/movers', {}));

  Future<TickerDetail> ticker(String key) async => TickerDetail.fromMap(await _api.get('/api/ticker', {'key': key}));

  Future<ChartData> chart(String key, ChartRange range) async =>
      ChartData.fromMap(await _api.get('/api/chart', {'key': key, 'range': range.code}));
}
