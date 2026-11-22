// 시작: Firebase → DI 준비 → (가이드를 이미 봤으면) 목표가 알림 등록 시작 → 앱(런치 애니메이션부터).
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'app.dart';
import 'core/di/injection.dart';
import 'core/router/app_router.dart';
import 'features/alerts/presentation/alerts_cubit.dart';
import 'features/settings/data/settings_repository.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await configureDependencies();
  // 처음 실행이면 가이드 마지막 장에서 설명한 뒤 권한을 묻는다. 기다리지 않는다(첫 화면이 늦게 뜨지 않게)
  if (getIt<SettingsRepository>().guideSeen()) {
    getIt<AlertsCubit>().start(WidgetsBinding.instance.platformDispatcher.locale.languageCode);
  }
  runApp(PartstockApp(router: createRouter()));
}
