// 앱 맨 위: 앱 전체 수명 Cubit(관심 종목·설정)을 깔고 라우터·언어·테마를 붙인다.
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'core/di/injection.dart';
import 'features/settings/presentation/settings_cubit.dart';
import 'features/watchlist/presentation/watchlist_cubit.dart';
import 'l10n/app_localizations.dart';

class PartstockApp extends StatelessWidget {
  const PartstockApp({super.key, required this.router});

  final GoRouter router;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: getIt<WatchlistCubit>()),
        BlocProvider.value(value: getIt<SettingsCubit>()),
      ],
      child: MaterialApp.router(
        title: 'partstock',
        routerConfig: router,
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
