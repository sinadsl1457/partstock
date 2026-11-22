// 외부 객체(http, SharedPreferences, 시계, API 주소)를 DI에 등록.
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../time/clock.dart';

@module
abstract class AppModule {
  @lazySingleton
  http.Client get httpClient => http.Client();

  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

  @lazySingleton
  Clock get clock => SystemClock();

  /// flutter run --dart-define=API_URL=http://10.0.2.2:8080 (에뮬레이터에서 내 컴퓨터 서버)
  @Named('apiUrl')
  String get apiUrl => const String.fromEnvironment('API_URL', defaultValue: 'https://32-236-106-139.sslip.io');
}
