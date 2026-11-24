// 화면 흐름: 시세 목록 → 종목 차트 → 별 → 관심 탭. 가짜 저장소(실제 API 응답 예시)로 앱 전체를 띄운다.
import 'package:flutter/foundation.dart' show debugDefaultTargetPlatformOverride;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:partstock/app.dart';
import 'package:partstock/core/di/injection.dart';
import 'package:partstock/core/network/app_failure.dart';
import 'package:partstock/core/push/push_service.dart';
import 'package:partstock/core/router/app_router.dart';
import 'package:partstock/features/alerts/data/alert_models.dart';
import 'package:partstock/features/alerts/presentation/alerts_cubit.dart';
import 'package:partstock/features/board/data/board_filter_repository.dart';
import 'package:partstock/features/board/presentation/board_cubit.dart';
import 'package:partstock/features/market/data/market_models.dart';
import 'package:partstock/features/market/data/market_repository.dart';
import 'package:partstock/features/movers/presentation/movers_cubit.dart';
import 'package:partstock/features/settings/data/settings_repository.dart';
import 'package:partstock/features/settings/presentation/settings_cubit.dart';
import 'package:partstock/features/ticker/presentation/ticker_cubit.dart';
import 'package:partstock/features/watchlist/data/watchlist_repository.dart';
import 'package:partstock/features/watchlist/presentation/watch_prices_cubit.dart';
import 'package:partstock/features/watchlist/presentation/watchlist_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/fakes.dart';
import '../helpers/fixtures.dart';

late MockAlertsRepo alertsRepo;

Future<MockMarketRepo> setUpDi() async {
  await getIt.reset();
  SharedPreferences.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();
  final repo = MockMarketRepo();
  alertsRepo = MockAlertsRepo();
  when(
    () => alertsRepo.registerDevice(
      any(),
      platform: any(named: 'platform'),
      locale: any(named: 'locale'),
    ),
  ).thenAnswer((_) async {});
  when(() => alertsRepo.list(any())).thenAnswer((_) async => []);
  final push = FakePush();
  final alerts = AlertsCubit(push, alertsRepo);
  await alerts.start('ko');
  getIt
    ..registerSingleton<MarketRepository>(repo)
    ..registerSingleton<PushService>(push)
    ..registerSingleton(alerts)
    ..registerSingleton(WatchlistCubit(WatchlistRepository(prefs)))
    ..registerSingleton(SettingsCubit(SettingsRepository(prefs)))
    ..registerFactory(() => BoardCubit(repo, BoardFilterRepository(prefs)))
    ..registerFactory(() => MoversCubit(repo))
    ..registerFactory(() => WatchPricesCubit(repo))
    ..registerFactoryParam<TickerCubit, String, void>((key, _) => TickerCubit(repo, key));
  return repo;
}

void main() {
  setUpAll(() {
    registerFallbackValue(Category.gpu);
    registerFallbackValue(ChartRange.d1);
    registerFallbackValue(AlertDirection.below);
  });

  testWidgets('목록에서 종목을 누르면 차트, 별을 누르면 관심 탭에 나온다', (tester) async {
    final repo = await setUpDi();
    when(() => repo.cachedBoard(any())).thenReturn(null);
    when(() => repo.board(any())).thenAnswer((_) async => boardFixture());
    when(() => repo.ticker(any())).thenAnswer((_) async => tickerFixture());
    when(() => repo.chart(any(), any())).thenAnswer((i) async => chartFixture(i.positionalArguments[1] as ChartRange));
    tester.platformDispatcher.localesTestValue = const [Locale('ko')];
    addTearDown(tester.platformDispatcher.clearLocalesTestValue);
    // 기본 테스트 화면(800×600)은 작아서 아래쪽 목록이 안 만들어진다 → 에뮬레이터와 같은 폰 크기
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.625;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(PartstockApp(router: createRouter(initialLocation: '/board')));
    await tester.pumpAndSettle();

    expect(find.text('RTX 5070 Ti'), findsOneWidget);
    await tester.tap(find.text('RTX 5070 Ti'));
    await tester.pumpAndSettle();

    // 차트 화면: 원화 대표가, 기간 버튼, 제조사 목록
    expect(find.textContaining('만원'), findsWidgets);
    expect(find.text('1주'), findsOneWidget);
    expect(find.text('제조사별'), findsOneWidget);

    await tester.tap(find.text('1주'));
    await tester.pumpAndSettle();
    verify(() => repo.chart('rtx-5070-ti', ChartRange.w1)).called(1);

    await tester.tap(find.byTooltip('관심 종목에 추가'));
    await tester.pumpAndSettle();
    expect(find.byTooltip('관심 종목에서 빼기'), findsOneWidget);

    await tester.tap(find.byType(BackButtonIcon));
    await tester.pumpAndSettle();
    await tester.tap(find.text('관심'));
    await tester.pumpAndSettle();
    expect(find.text('RTX 5070 Ti'), findsOneWidget);
  });

  testWidgets('처음부터 연결이 안 되면 안내와 다시 시도, 다시 시도하면 목록', (tester) async {
    final repo = await setUpDi();
    var fail = true;
    when(() => repo.cachedBoard(any())).thenReturn(null);
    when(() => repo.board(any())).thenAnswer((_) async {
      if (fail) throw const NetworkFailure();
      return boardFixture();
    });
    tester.platformDispatcher.localesTestValue = const [Locale('ko')];
    addTearDown(tester.platformDispatcher.clearLocalesTestValue);
    // 기본 테스트 화면(800×600)은 작아서 아래쪽 목록이 안 만들어진다 → 에뮬레이터와 같은 폰 크기
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.625;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(PartstockApp(router: createRouter(initialLocation: '/board')));
    await tester.pumpAndSettle();
    expect(find.text('인터넷에 연결할 수 없습니다.'), findsOneWidget);

    fail = false;
    await tester.tap(find.text('다시 시도'));
    await tester.pumpAndSettle();
    expect(find.text('RTX 5090'), findsOneWidget);
  });

  testWidgets('종 버튼 → 목표가 창 → 알림 켜기 → 차트와 관심 탭에 알림이 보인다', (tester) async {
    final repo = await setUpDi();
    when(() => repo.cachedBoard(any())).thenReturn(null);
    when(() => repo.board(any())).thenAnswer((_) async => boardFixture());
    when(() => repo.ticker(any())).thenAnswer((_) async => tickerFixture());
    when(() => repo.chart(any(), any())).thenAnswer((i) async => chartFixture(i.positionalArguments[1] as ChartRange));
    when(() => repo.ticker(any())).thenAnswer((_) async => tickerFixture());
    when(() => alertsRepo.create(any(), any(), any(), any())).thenAnswer(
      (i) async => PriceAlert(
        id: 7,
        tickerKey: i.positionalArguments[1] as String,
        tickerName: 'RTX 5070 Ti',
        direction: i.positionalArguments[2] as AlertDirection,
        targetCents: i.positionalArguments[3] as int,
        createdAt: DateTime.utc(2026, 11, 22),
      ),
    );
    tester.platformDispatcher.localesTestValue = const [Locale('ko')];
    addTearDown(tester.platformDispatcher.clearLocalesTestValue);
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.625;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(PartstockApp(router: createRouter(initialLocation: '/board')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('RTX 5070 Ti'));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('목표가 알림'));
    await tester.pumpAndSettle();
    expect(find.text('알림 켜기'), findsOneWidget);
    await tester.tap(find.text('알림 켜기'));
    await tester.pumpAndSettle();

    // 기본: 지금보다 5% 낮은 가격, 이하
    final call = verify(() => alertsRepo.create('token-1', 'rtx-5070-ti', AlertDirection.below, captureAny()));
    call.called(1);
    final p25 = tickerFixture().price!.priceCents;
    expect((call.captured.single as int) / p25, closeTo(0.95, 0.001));
    expect(find.text('알림을 켰습니다'), findsOneWidget);
    expect(find.byIcon(Icons.notifications_active_outlined), findsOneWidget); // 현재가 아래 알림 표시

    await tester.tap(find.byType(BackButtonIcon));
    await tester.pumpAndSettle();
    await tester.tap(find.text('관심'));
    await tester.pumpAndSettle();
    expect(find.text('목표가 알림'), findsOneWidget);
    expect(find.textContaining('이하'), findsOneWidget);
  });

  // 11/22 사용자 발견: iOS에서 종목 차트를 왼쪽 끝에서 오른쪽으로 밀어도 뒤로 안 감.
  // go_router 18이 Flutter 기본 MaterialApp을 못 알아봐서 모든 화면이 전환 없는 페이지였다
  testWidgets('iOS: 종목 차트에서 왼쪽 끝을 오른쪽으로 밀면 목록으로 돌아간다', (tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    final repo = await setUpDi();
    when(() => repo.cachedBoard(any())).thenReturn(null);
    when(() => repo.board(any())).thenAnswer((_) async => boardFixture());
    when(() => repo.ticker(any())).thenAnswer((_) async => tickerFixture());
    when(() => repo.chart(any(), any())).thenAnswer((i) async => chartFixture(i.positionalArguments[1] as ChartRange));
    tester.platformDispatcher.localesTestValue = const [Locale('ko')];
    addTearDown(tester.platformDispatcher.clearLocalesTestValue);
    tester.view.physicalSize = const Size(1179, 2556); // iPhone 크기
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(PartstockApp(router: createRouter(initialLocation: '/board')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('RTX 5070 Ti'));
    await tester.pumpAndSettle();
    expect(find.text('제조사별'), findsOneWidget);

    // 화면 왼쪽 끝(5px)에서 오른쪽으로 길게
    final g = await tester.startGesture(const Offset(5, 400));
    for (var i = 0; i < 10; i++) {
      await g.moveBy(const Offset(30, 0));
      await tester.pump(const Duration(milliseconds: 16));
    }
    await g.up();
    await tester.pumpAndSettle();

    expect(find.text('제조사별'), findsNothing);
    expect(find.text('RTX 5090'), findsOneWidget);
    debugDefaultTargetPlatformOverride = null;
  });
}
