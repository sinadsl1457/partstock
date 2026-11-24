// 화면 주소 전부. 런치(/launch) → 처음이면 가이드(/guide) → 탭(시세·관심·설정, StatefulShellRoute).
// 종목 차트는 탭 위로 띄운다(/ticker?key=...).
// 종목 키에 '/'가 들어가서(rtx-5070-ti/msi) 경로가 아니라 쿼리로 넘긴다.
// 화면은 모두 pageBuilder로 MaterialPage를 직접 만든다: go_router 18은 material_ui 패키지의 MaterialApp만
// 알아봐서 Flutter 기본 MaterialApp을 쓰면 전환 없는 페이지를 만든다(iOS 밀어서 뒤로가기·밀려 들어오는 전환이 없어짐, 11/22).
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/board/presentation/board_cubit.dart';
import '../../features/board/presentation/board_screen.dart';
import '../../features/movers/presentation/movers_cubit.dart';
import '../../features/market/data/market_models.dart';
import '../../features/onboarding/presentation/guide_screen.dart';
import '../../features/onboarding/presentation/launch_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/ticker/presentation/ticker_cubit.dart';
import '../../features/ticker/presentation/ticker_screen.dart';
import '../../features/watchlist/presentation/watch_prices_cubit.dart';
import '../../features/watchlist/presentation/watch_screen.dart';
import '../../features/watchlist/presentation/watchlist_cubit.dart';
import '../di/injection.dart';
import '../presentation/app_shell.dart';

/// 테스트에서는 매번 새로 만든다(라우터 상태가 테스트끼리 섞이지 않게). 화면 테스트는 /board에서 시작할 수 있다.
/// iOS는 밀어서 들어오는 전환 + 왼쪽 끝에서 밀어 뒤로가기, Android는 기본 전환
Page<void> _page(GoRouterState state, Widget child) => MaterialPage<void>(key: state.pageKey, child: child);

GoRouter createRouter({String initialLocation = '/launch'}) => GoRouter(
  initialLocation: initialLocation,
  routes: [
    GoRoute(path: '/launch', pageBuilder: (_, s) => _page(s, const LaunchScreen())),
    GoRoute(
      path: '/guide',
      pageBuilder: (_, state) => _page(state, GuideScreen(again: state.uri.queryParameters['again'] == '1')),
    ),
    StatefulShellRoute.indexedStack(
      pageBuilder: (_, state, shell) => _page(state, AppShell(shell: shell)),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/board',
              pageBuilder: (_, s) => _page(
                s,
                MultiBlocProvider(
                  providers: [
                    BlocProvider(create: (_) => getIt<BoardCubit>()..select(Category.gpu)),
                    // 급등락 탭은 시세 탭과 함께 살고, 그 탭을 처음 열 때 받는다
                    BlocProvider(create: (_) => getIt<MoversCubit>()),
                  ],
                  child: const BoardScreen(),
                ),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/watch',
              pageBuilder: (_, s) => _page(
                s,
                BlocProvider(
                  create: (_) => getIt<WatchPricesCubit>()..load(getIt<WatchlistCubit>().state),
                  child: const WatchScreen(),
                ),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [GoRoute(path: '/settings', pageBuilder: (_, s) => _page(s, const SettingsScreen()))],
        ),
      ],
    ),
    GoRoute(
      path: '/ticker',
      pageBuilder: (_, state) {
        final key = state.uri.queryParameters['key'] ?? '';
        return _page(
          state,
          BlocProvider(
            // 종목마다 따로: 같은 화면에서 제조사로 내려가도 새 Cubit
            key: ValueKey(key),
            create: (_) => getIt<TickerCubit>(param1: key)..load(),
            child: const TickerScreen(),
          ),
        );
      },
    ),
  ],
);
