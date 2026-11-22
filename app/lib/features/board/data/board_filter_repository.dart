// 시세 목록 필터 저장(SharedPreferences, 분류마다). 앱을 다시 켜도 고른 필터가 남는다.
import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../market/data/market_models.dart';
import 'board_filter.dart';

@lazySingleton
class BoardFilterRepository {
  BoardFilterRepository(this._prefs);

  final SharedPreferences _prefs;

  String _key(Category c) => 'board.filter.${c.name}';

  BoardFilter load(Category c) {
    final raw = _prefs.getString(_key(c));
    if (raw == null) return initialFilter(c);
    try {
      return filterFromJson(c, jsonDecode(raw) as Map<String, dynamic>);
    } on FormatException {
      return initialFilter(c);
    }
  }

  Future<void> save(Category c, BoardFilter f) => _prefs.setString(_key(c), jsonEncode(filterToJson(f)));
}
