// 시세 목록 필터 흐름: RAM은 처음에 1개짜리만, 필터 창에서 2개 묶음으로 바꾸면 목록이 바뀐다.
// VGA는 시리즈를 골라 40 시리즈만 본다. 값이 없는 종목은 "데이터 없음".
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:partstock/app.dart';
import 'package:partstock/core/di/injection.dart';
import 'package:partstock/core/push/push_service.dart';
import 'package:partstock/core/router/app_router.dart';
import 'package:partstock/features/alerts/presentation/alerts_cubit.dart';
import 'package:partstock/features/board/data/board_filter_repository.dart';
import 'package:partstock/features/board/presentation/board_cubit.dart';
import 'package:partstock/features/market/data/market_models.dart';
import 'package:partstock/features/market/data/market_repository.dart';
import 'package:partstock/features/movers/presentation/movers_cubit.dart';
import 'package:partstock/features/settings/data/settings_repository.dart';
import 'package:partstock/features/settings/presentation/settings_cubit.dart';
import 'package:partstock/features/watchlist/data/watchlist_repository.dart';
import 'package:partstock/features/watchlist/presentation/watchlist_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/fakes.dart';
import '../helpers/fixtures.dart';

Future<void> setUpApp() async {
  await getIt.reset();
  SharedPreferences.setMockInitialValues({'settings.guideSeen': true});
  final prefs = await SharedPreferences.getInstance();
  final market = MockMarketRepo();
  when(() => market.cachedBoard(any())).thenReturn(null);
  when(() => market.movers()).thenAnswer((_) async => moversFixture());
  when(() => market.board(Category.gpu)).thenAnswer((_) async => boardFixture());
  when(() => market.board(Category.ram)).thenAnswer((_) async => boardFixture('board_ram'));
  when(() => market.board(Category.cpu)).thenAnswer((_) async => boardFixture('board_cpu'));
  when(() => market.board(Category.ssd)).thenAnswer((_) async => boardFixture('board_ssd'));
  final push = FakePush();
  getIt
    ..registerSingleton<MarketRepository>(market)
    ..registerSingleton<PushService>(push)
    ..registerSingleton(AlertsCubit(push, MockAlertsRepo()))
    ..registerSingleton(WatchlistCubit(WatchlistRepository(prefs)))
    ..registerSingleton(SettingsCubit(SettingsRepository(prefs)))
    ..registerFactory(() => BoardCubit(market, BoardFilterRepository(prefs)))
    ..registerFactory(() => MoversCubit(market));
}

void main() {
  setUpAll(() => registerFallbackValue(Category.gpu));

  Future<void> open(WidgetTester tester) async {
    tester.platformDispatcher.localesTestValue = const [Locale('ko')];
    addTearDown(tester.platformDispatcher.clearLocalesTestValue);
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.625;
    addTearDown(tester.view.reset);
    await setUpApp();
    await tester.pumpWidget(PartstockApp(router: createRouter(initialLocation: '/board')));
    await tester.pumpAndSettle();
  }

  testWidgets('RAM: 처음엔 1개짜리만(값 없으면 데이터 없음), 필터에서 2개 묶음을 고르면 바뀐다', (tester) async {
    await open(tester);
    await tester.tap(find.text('RAM').first);
    await tester.pumpAndSettle();

    expect(find.text('DDR5 16GB'), findsOneWidget);
    expect(find.text('DDR5 32GB (2×16GB)'), findsNothing);
    expect(find.text('데이터 없음'), findsWidgets);

    await tester.tap(find.text('필터'));
    await tester.pumpAndSettle();
    expect(find.text('RAM 필터'), findsOneWidget);
    await tester.tap(find.text('2개 묶음'));
    await tester.pump();
    await tester.tap(find.text('DDR5'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('4개 종목 보기'));
    await tester.pumpAndSettle();

    expect(find.text('DDR5 32GB (2×16GB)'), findsOneWidget);
    expect(find.text('DDR5 16GB'), findsNothing);
    expect(find.text('DDR4 16GB (2×8GB)'), findsNothing);
    expect(find.text('필터 2'), findsOneWidget); // 처음 값과 다른 묶음 2개
  });

  testWidgets('VGA: RTX 40만 고르면 40 시리즈만, 초기화하면 전체', (tester) async {
    await open(tester);
    expect(find.text('RTX 5090'), findsOneWidget);

    await tester.tap(find.text('필터'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('RTX 40'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('2개 종목 보기'));
    await tester.pumpAndSettle();

    expect(find.text('RTX 4090'), findsOneWidget);
    expect(find.text('RTX 4070'), findsOneWidget);
    expect(find.text('RTX 5090'), findsNothing);

    await tester.tap(find.text('필터 1'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('초기화'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('14개 종목 보기'));
    await tester.pumpAndSettle();
    expect(find.text('RTX 5090'), findsOneWidget);
    expect(find.text('필터'), findsOneWidget);
  });

  testWidgets('CPU 탭: Intel · 14세대만 고르면 14세대 Intel만', (tester) async {
    await open(tester);
    await tester.tap(find.text('CPU').first);
    await tester.pumpAndSettle();
    expect(find.text('Ryzen 7 9800X3D'), findsOneWidget);

    await tester.tap(find.text('필터'));
    await tester.pumpAndSettle();
    expect(find.text('CPU 필터'), findsOneWidget);
    await tester.tap(find.text('Intel'));
    await tester.pump();
    await tester.tap(find.text('Core 14세대'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('5개 종목 보기'));
    await tester.pumpAndSettle();

    expect(find.text('Core i7-14700K'), findsOneWidget);
    expect(find.text('Ryzen 7 9800X3D'), findsNothing);
    expect(find.text('Core Ultra 9 285K'), findsNothing);
    expect(find.text('필터 2'), findsOneWidget);
  });

  testWidgets('SSD 탭: 4TB · SATA → Samsung 870 EVO 4TB만, 목록에 규격 표시', (tester) async {
    await open(tester);
    await tester.tap(find.text('SSD').first);
    await tester.pumpAndSettle();
    expect(find.text('Samsung 990 PRO 1TB'), findsOneWidget);
    expect(find.text('NVMe Gen4'), findsWidgets);

    await tester.tap(find.text('필터'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('4TB'));
    await tester.pump();
    await tester.tap(find.text('SATA'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('1개 종목 보기'));
    await tester.pumpAndSettle();

    expect(find.text('Samsung 870 EVO 4TB'), findsOneWidget);
    expect(find.text('Samsung 990 PRO 1TB'), findsNothing);
  });
}
