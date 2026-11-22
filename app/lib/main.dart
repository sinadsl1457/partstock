// 시작: Firebase → DI 준비 → 목표가 알림 등록 시작 → 앱.
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'app.dart';
import 'core/di/injection.dart';
import 'core/router/app_router.dart';
import 'features/alerts/presentation/alerts_cubit.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await configureDependencies();
  // 권한 묻기·서버 등록은 기다리지 않는다(첫 화면이 늦게 뜨지 않게)
  getIt<AlertsCubit>().start(WidgetsBinding.instance.platformDispatcher.locale.languageCode);
  runApp(PartstockApp(router: createRouter()));
}
