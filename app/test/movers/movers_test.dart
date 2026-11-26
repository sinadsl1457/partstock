// 급등락: Cubit은 탭을 처음 열 때만 받고, 화면은 시세 탭의 분류 탭 옆에서 순위를 보여 주고 누르면 종목 차트로 간다.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:partstock/app.dart';
import 'package:partstock/core/network/app_failure.dart';
import 'package:partstock/core/router/app_router.dart';
import 'package:partstock/features/alerts/data/alert_models.dart';
import 'package:partstock/features/market/data/market_models.dart';
import 'package:partstock/features/movers/presentation/movers_cubit.dart';

import '../flow/app_flow_test.dart' show setUpDi;
import '../helpers/fakes.dart';
import '../helpers/fixtures.dart';

Future<void> pumpApp(WidgetTester tester) async {
  tester.platformDispatcher.localesTestValue = const [Locale('ko')];
  addTearDown(tester.platformDispatcher.clearLocalesTestValue);
  tester.view.physicalSize = const Size(1080, 2400);
  tester.view.devicePixelRatio = 2.625;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(PartstockApp(router: createRouter(initialLocation: '/board')));
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(() {
    registerFallbackValue(Category.gpu);
    registerFallbackValue(ChartRange.d1);
    registerFallbackValue(AlertDirection.below);
  });

  group('MoversCubit', () {
    test('처음 열 때만 받고, 다시 받다 실패하면 보던 순위는 그대로', () async {
      final repo = MockMarketRepo();
      when(() => repo.movers()).thenAnswer((_) async => moversFixture());
      final c = MoversCubit(repo);

      await c.open();
      await c.open();
      verify(() => repo.movers()).called(1);

      when(() => repo.movers()).thenThrow(const NetworkFailure());
      await c.refresh();
      expect(c.state.movers!.up, hasLength(2));
      expect(c.state.failure, isA<NetworkFailure>());
    });
  });

  testWidgets('급등락 탭: 순위·분류를 보여 주고 필터는 숨김, 누르면 차트, VGA로 돌아오면 목록', (tester) async {
    final repo = await setUpDi();
    when(() => repo.cachedBoard(any())).thenReturn(null);
    when(() => repo.board(any())).thenAnswer((_) async => boardFixture());
    when(() => repo.movers()).thenAnswer((_) async => moversFixture());
    when(() => repo.ticker(any())).thenAnswer((_) async => tickerFixture());
    when(() => repo.chart(any(), any())).thenAnswer((i) async => chartFixture(i.positionalArguments[1] as ChartRange));
    await pumpApp(tester);
    verify(() => repo.movers()).called(1); // 시세 탭을 열 때 네 분류와 같이 미리 받는다
    expect(find.text('필터'), findsOneWidget);

    await tester.tap(find.text('급등락'));
    await tester.pumpAndSettle();
    verifyNever(() => repo.movers()); // 탭을 열 때는 다시 받지 않는다

    expect(find.text('급등 TOP 5'), findsOneWidget);
    expect(find.text('급락 TOP 5'), findsOneWidget);
    expect(find.text('RX 9070 XT'), findsOneWidget);
    expect(find.text('RAM · 글 412'), findsOneWidget);
    expect(find.text('▲ 4.21%'), findsOneWidget);
    expect(find.text('▼ 5.30%'), findsOneWidget);
    expect(find.text('필터'), findsNothing);
    expect(find.text('종목 · 미국 eBay 기준'), findsNothing);

    await tester.tap(find.text('RTX 5080'));
    await tester.pumpAndSettle();
    verify(() => repo.ticker('rtx-5080')).called(1);

    await tester.tap(find.byType(BackButtonIcon));
    await tester.pumpAndSettle();
    expect(find.text('급등 TOP 5'), findsOneWidget); // 돌아와도 급등락 탭 그대로

    await tester.tap(find.text('VGA'));
    await tester.pumpAndSettle();
    expect(find.text('RTX 5090'), findsOneWidget);
    expect(find.text('필터'), findsOneWidget);
  });

  testWidgets('오른 종목이 없으면 안내 문구', (tester) async {
    final repo = await setUpDi();
    when(() => repo.cachedBoard(any())).thenReturn(null);
    when(() => repo.board(any())).thenAnswer((_) async => boardFixture());
    when(() => repo.movers()).thenAnswer((_) async => moversFixture().copyWith(up: []));
    await pumpApp(tester);

    await tester.tap(find.text('급등락'));
    await tester.pumpAndSettle();

    expect(find.text('24시간 동안 오른 종목이 없습니다.'), findsOneWidget);
    expect(find.text('RTX 5080'), findsOneWidget);
  });
}
