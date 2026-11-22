// 설정 저장(SharedPreferences): 바로가기 기본값, 가이드를 본 적 있는지.
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Jump { ebay, danawa }

@lazySingleton
class SettingsRepository {
  SettingsRepository(this._prefs);

  final SharedPreferences _prefs;
  static const _jump = 'settings.jump';
  static const _guide = 'settings.guideSeen';

  Jump jump() => _prefs.getString(_jump) == 'danawa' ? Jump.danawa : Jump.ebay;

  Future<void> setJump(Jump j) => _prefs.setString(_jump, j.name);

  bool guideSeen() => _prefs.getBool(_guide) ?? false;

  Future<void> setGuideSeen() => _prefs.setBool(_guide, true);
}
