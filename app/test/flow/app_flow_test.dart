// 화면 흐름: 시세 목록 → 종목 차트 → 별 → 관심 탭. 가짜 저장소(실제 API 응답 예시)로 앱 전체를 띄운다.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:partstock/app.dart';
import 'package:partstock/core/di/injection.dart';
import 'package:partstock/core/network/app_failure.dart';
import 'package:partstock/core/router/app_router.dart';
import 'package:partstock/features/board/presentation/board_cubit.dart';
import 'package:partstock/features/market/data/market_models.dart';
import 'package:partstock/features/market/data/market_repository.dart';
import 'package:partstock/features/settings/data/settings_repository.dart';
import 'package:partstock/features/settings/presentation/settings_cubit.dart';
import 'package:partstock/features/ticker/presentation/ticker_cubit.dart';
import 'package:partstock/features/watchlist/data/watchlist_repository.dart';
import 'package:partstock/features/watchlist/presentation/watch_prices_cubit.dart';
import 'package:partstock/features/watchlist/presentation/watchlist_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/fixtures.dart';

class MockRepo extends Mock implements MarketRepository {}

Future<MockRepo> setUpDi() async {
  await getIt.reset();
  SharedPreferences.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();
  final repo = MockRepo();
  getIt
    ..registerSingleton<MarketRepository>(repo)
    ..registerSingleton(WatchlistCubit(WatchlistRepository(prefs)))
    ..registerSingleton(SettingsCubit(SettingsRepository(prefs)))
    ..registerFactory(() => BoardCubit(repo))
    ..registerFactory(() => WatchPricesCubit(repo))
    ..registerFactoryParam<TickerCubit, String, void>((key, _) => TickerCubit(repo, key));
  return repo;
}

void main() {
  setUpAll(() {
    registerFallbackValue(Category.gpu);
    registerFallbackValue(ChartRange.d1);
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

    await tester.pumpWidget(PartstockApp(router: createRouter()));
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

    await tester.pumpWidget(PartstockApp(router: createRouter()));
    await tester.pumpAndSettle();
    expect(find.text('인터넷에 연결할 수 없습니다.'), findsOneWidget);

    fail = false;
    await tester.tap(find.text('다시 시도'));
    await tester.pumpAndSettle();
    expect(find.text('RTX 5090'), findsOneWidget);
  });
}
