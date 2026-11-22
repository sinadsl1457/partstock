// 관심 종목 키 목록을 폰에 저장(SharedPreferences). 넣은 순서대로.
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@lazySingleton
class WatchlistRepository {
  WatchlistRepository(this._prefs);

  final SharedPreferences _prefs;
  static const _key = 'watchlist';

  List<String> load() => _prefs.getStringList(_key) ?? const [];

  Future<void> save(List<String> keys) => _prefs.setStringList(_key, keys);
}
