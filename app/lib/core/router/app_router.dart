// 화면 주소 전부. 탭(시세·관심·설정)은 StatefulShellRoute, 종목 차트는 탭 위로 띄운다(/ticker?key=...).
// 종목 키에 '/'가 들어가서(rtx-5070-ti/msi) 경로가 아니라 쿼리로 넘긴다.
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/board/presentation/board_cubit.dart';
import '../../features/board/presentation/board_screen.dart';
import '../../features/market/data/market_models.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/ticker/presentation/ticker_cubit.dart';
import '../../features/ticker/presentation/ticker_screen.dart';
import '../../features/watchlist/presentation/watch_prices_cubit.dart';
import '../../features/watchlist/presentation/watch_screen.dart';
import '../../features/watchlist/presentation/watchlist_cubit.dart';
import '../di/injection.dart';
import '../presentation/app_shell.dart';

/// 테스트에서는 매번 새로 만든다(라우터 상태가 테스트끼리 섞이지 않게).
GoRouter createRouter() => GoRouter(
  initialLocation: '/board',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, shell) => AppShell(shell: shell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/board',
              builder: (_, _) =>
                  BlocProvider(create: (_) => getIt<BoardCubit>()..select(Category.gpu), child: const BoardScreen()),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/watch',
              builder: (_, _) => BlocProvider(
                create: (_) => getIt<WatchPricesCubit>()..load(getIt<WatchlistCubit>().state),
                child: const WatchScreen(),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [GoRoute(path: '/settings', builder: (_, _) => const SettingsScreen())],
        ),
      ],
    ),
    GoRoute(
      path: '/ticker',
      builder: (_, state) {
        final key = state.uri.queryParameters['key'] ?? '';
        return BlocProvider(
          // 종목마다 따로: 같은 화면에서 제조사로 내려가도 새 Cubit
          key: ValueKey(key),
          create: (_) => getIt<TickerCubit>(param1: key)..load(),
          child: const TickerScreen(),
        );
      },
    ),
  ],
);
