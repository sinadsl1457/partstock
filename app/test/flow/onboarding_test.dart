// 처음 실행 흐름: 런치 애니메이션 → 가이드 3장 → 시세 목록. 가이드를 본 뒤로는 런치 → 바로 목록.
// 알림 권한은 가이드 마지막 장 "알림 허용하고 시작"에서만 묻는다(건너뛰면 안 물음).
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:partstock/app.dart';
import 'package:partstock/core/di/injection.dart';
import 'package:partstock/core/push/push_service.dart';
import 'package:partstock/core/router/app_router.dart';
import 'package:partstock/features/alerts/presentation/alerts_cubit.dart';
import 'package:partstock/features/alerts/presentation/alerts_state.dart';
import 'package:partstock/features/board/data/board_filter_repository.dart';
import 'package:partstock/features/board/presentation/board_cubit.dart';
import 'package:partstock/features/market/data/market_models.dart';
import 'package:partstock/features/market/data/market_repository.dart';
import 'package:partstock/features/settings/data/settings_repository.dart';
import 'package:partstock/features/settings/presentation/settings_cubit.dart';
import 'package:partstock/features/watchlist/data/watchlist_repository.dart';
import 'package:partstock/features/watchlist/presentation/watchlist_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/fakes.dart';
import '../helpers/fixtures.dart';

class CountingPush extends FakePush {
  int permissionAsks = 0;

  @override
  Future<bool> requestPermission() async {
    permissionAsks++;
    return true;
  }
}

Future<CountingPush> setUp({required bool guideSeen}) async {
  await getIt.reset();
  SharedPreferences.setMockInitialValues({'settings.guideSeen': guideSeen});
  final prefs = await SharedPreferences.getInstance();
  final market = MockMarketRepo();
  when(() => market.cachedBoard(any())).thenReturn(null);
  when(() => market.board(any())).thenAnswer((_) async => boardFixture());
  final alertsRepo = MockAlertsRepo();
  when(
    () => alertsRepo.registerDevice(
      any(),
      platform: any(named: 'platform'),
      locale: any(named: 'locale'),
    ),
  ).thenAnswer((_) async {});
  when(() => alertsRepo.list(any())).thenAnswer((_) async => []);
  final push = CountingPush();
  getIt
    ..registerSingleton<MarketRepository>(market)
    ..registerSingleton<PushService>(push)
    ..registerSingleton(AlertsCubit(push, alertsRepo))
    ..registerSingleton(WatchlistCubit(WatchlistRepository(prefs)))
    ..registerSingleton(SettingsCubit(SettingsRepository(prefs)))
    ..registerFactory(() => BoardCubit(market, BoardFilterRepository(prefs)));
  return push;
}

/// 런치 애니메이션(1.4초)이 끝나고 0.18초 쉰 뒤 넘어가는 것까지 기다린다.
/// pumpAndSettle은 그리기만 기다리고 쉬는 타이머는 안 기다려서 따로 흘려보낸다.
Future<void> passLaunch(WidgetTester tester) async {
  await tester.pumpAndSettle();
  await tester.pump(const Duration(milliseconds: 250));
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(() => registerFallbackValue(Category.gpu));

  void phone(WidgetTester tester) {
    tester.platformDispatcher.localesTestValue = const [Locale('ko')];
    addTearDown(tester.platformDispatcher.clearLocalesTestValue);
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.625;
    addTearDown(tester.view.reset);
  }

  testWidgets('처음: 런치 → 가이드 3장 → 알림 허용하고 시작 → 목록, 권한은 그때 한 번', (tester) async {
    final push = await setUp(guideSeen: false);
    phone(tester);

    await tester.pumpWidget(PartstockApp(router: createRouter()));
    expect(find.text('VGA · RAM · CPU 시세'), findsOneWidget); // 런치 화면
    await passLaunch(tester);

    expect(find.text('VGA·RAM·CPU 시세를\n한눈에'), findsOneWidget);
    expect(push.permissionAsks, 0); // 설명 전에는 묻지 않는다
    await tester.tap(find.text('다음'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('다음'));
    await tester.pumpAndSettle();
    expect(find.text('원하는 가격이 되면\n알려 드려요'), findsOneWidget);

    await tester.tap(find.text('알림 허용하고 시작'));
    await tester.pumpAndSettle();

    expect(find.text('RTX 5070 Ti'), findsOneWidget);
    expect(push.permissionAsks, 1);
    expect(getIt<AlertsCubit>().state.status, AlertsStatus.ready);
    expect(getIt<SettingsCubit>().state.guideSeen, isTrue);
  });

  testWidgets('건너뛰면 권한을 묻지 않고 목록으로', (tester) async {
    final push = await setUp(guideSeen: false);
    phone(tester);

    await tester.pumpWidget(PartstockApp(router: createRouter()));
    await passLaunch(tester);
    await tester.tap(find.text('건너뛰기'));
    await tester.pumpAndSettle();

    expect(find.text('RTX 5070 Ti'), findsOneWidget);
    expect(push.permissionAsks, 0);
    expect(getIt<SettingsCubit>().state.guideSeen, isTrue);
  });

  testWidgets('가이드를 본 뒤로는 런치 → 바로 목록', (tester) async {
    await setUp(guideSeen: true);
    phone(tester);

    await tester.pumpWidget(PartstockApp(router: createRouter()));
    await passLaunch(tester);

    expect(find.text('RTX 5070 Ti'), findsOneWidget);
    expect(find.text('다음'), findsNothing);
  });

  testWidgets('런치 화면을 누르면 애니메이션을 기다리지 않고 넘어간다', (tester) async {
    await setUp(guideSeen: true);
    phone(tester);

    await tester.pumpWidget(PartstockApp(router: createRouter()));
    await tester.pump(const Duration(milliseconds: 200)); // 애니메이션 중간
    await tester.tap(find.text('VGA · RAM · CPU 시세'), warnIfMissed: false);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.text('RTX 5070 Ti'), findsOneWidget);
  });
}
