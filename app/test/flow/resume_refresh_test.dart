// 앱이 백그라운드에서 돌아오면 보고 있던 화면이 새로 받는다(당기거나 앱을 다시 켜지 않아도).
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:partstock/app.dart';
import 'package:partstock/core/router/app_router.dart';
import 'package:partstock/features/alerts/data/alert_models.dart';
import 'package:partstock/features/market/data/market_models.dart';

import '../helpers/fixtures.dart';
import 'app_flow_test.dart' show setUpDi;

Future<void> goBackground(WidgetTester tester) async {
  for (final s in [AppLifecycleState.inactive, AppLifecycleState.hidden, AppLifecycleState.paused]) {
    tester.binding.handleAppLifecycleStateChanged(s);
  }
}

Future<void> comeBack(WidgetTester tester) async {
  for (final s in [AppLifecycleState.hidden, AppLifecycleState.inactive, AppLifecycleState.resumed]) {
    tester.binding.handleAppLifecycleStateChanged(s);
  }
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(() {
    registerFallbackValue(Category.gpu);
    registerFallbackValue(ChartRange.d1);
    registerFallbackValue(AlertDirection.below);
  });

  testWidgets('백그라운드에서 돌아오면 목록·차트를 새로 받고, 알림창처럼 잠깐 가려진 건 받지 않는다', (tester) async {
    final repo = await setUpDi();
    when(() => repo.cachedBoard(any())).thenReturn(null);
    when(() => repo.board(any())).thenAnswer((_) async => boardFixture());
    when(() => repo.ticker(any())).thenAnswer((_) async => tickerFixture());
    when(() => repo.chart(any(), any())).thenAnswer((i) async => chartFixture(i.positionalArguments[1] as ChartRange));
    tester.platformDispatcher.localesTestValue = const [Locale('ko')];
    addTearDown(tester.platformDispatcher.clearLocalesTestValue);
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.625;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(PartstockApp(router: createRouter(initialLocation: '/board')));
    await tester.pumpAndSettle();
    verify(() => repo.board(Category.gpu)).called(1);

    // 알림창을 내렸다 올림: inactive만 거치고 화면은 계속 보임
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pumpAndSettle();
    verifyNever(() => repo.board(any()));

    await goBackground(tester);
    await comeBack(tester);
    verify(() => repo.board(Category.gpu)).called(1);

    await tester.tap(find.text('RTX 5070 Ti'));
    await tester.pumpAndSettle();
    verify(() => repo.ticker('rtx-5070-ti')).called(1);

    await goBackground(tester);
    await comeBack(tester);
    verify(() => repo.ticker('rtx-5070-ti')).called(1);
  });
}
