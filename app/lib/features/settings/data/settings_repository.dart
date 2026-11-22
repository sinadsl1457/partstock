// 설정 저장(SharedPreferences): 바로가기 기본값.
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Jump { ebay, danawa }

@lazySingleton
class SettingsRepository {
  SettingsRepository(this._prefs);

  final SharedPreferences _prefs;
  static const _jump = 'settings.jump';

  Jump jump() => _prefs.getString(_jump) == 'danawa' ? Jump.danawa : Jump.ebay;

  Future<void> setJump(Jump j) => _prefs.setString(_jump, j.name);
}
