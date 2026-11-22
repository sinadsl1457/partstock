// 앱 맨 위: 앱 전체 수명 Cubit(관심 종목·설정·목표가 알림)을 깔고 라우터·언어·테마를 붙인다.
// 알림을 눌러 열리면 그 종목 차트로, 앱이 켜져 있을 때 온 알림은 아래 안내로 보여 준다.
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'core/di/injection.dart';
import 'core/push/push_service.dart';
import 'features/alerts/presentation/alerts_cubit.dart';
import 'features/settings/presentation/settings_cubit.dart';
import 'features/watchlist/presentation/watchlist_cubit.dart';
import 'l10n/app_localizations.dart';

class PartstockApp extends StatefulWidget {
  const PartstockApp({super.key, required this.router});

  final GoRouter router;

  @override
  State<PartstockApp> createState() => _PartstockAppState();
}

class _PartstockAppState extends State<PartstockApp> {
  final _messenger = GlobalKey<ScaffoldMessengerState>();
  final _subs = <StreamSubscription<Object>>[];

  @override
  void initState() {
    super.initState();
    final push = getIt<PushService>();
    if (!push.supported) return;
    _subs
      ..add(push.openedTicker.listen((key) => widget.router.push('/ticker?key=${Uri.encodeQueryComponent(key)}')))
      ..add(
        push.foreground.listen((m) {
          _messenger.currentState?.showSnackBar(SnackBar(content: Text('${m.title}\n${m.body}')));
          getIt<AlertsCubit>().reload(); // 울린 알림을 목록에 반영
        }),
      );
  }

  @override
  void dispose() {
    for (final s in _subs) {
      s.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: getIt<WatchlistCubit>()),
        BlocProvider.value(value: getIt<SettingsCubit>()),
        BlocProvider.value(value: getIt<AlertsCubit>()),
      ],
      child: MaterialApp.router(
        title: 'partstock',
        scaffoldMessengerKey: _messenger,
        routerConfig: widget.router,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF111827), surface: Colors.white),
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(backgroundColor: Colors.white, surfaceTintColor: Colors.white),
          navigationBarTheme: const NavigationBarThemeData(backgroundColor: Colors.white),
        ),
      ),
    );
  }
}
