// 종목 차트: 처음엔 정보 + 1일 차트, 기간을 바꾸면 그 차트만 받고 한 번 받은 건 다시 안 받는다.
import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:partstock/core/network/app_failure.dart';
import 'package:partstock/features/market/data/market_models.dart';
import 'package:partstock/features/market/data/market_repository.dart';
import 'package:partstock/features/ticker/presentation/ticker_cubit.dart';
import 'package:partstock/features/ticker/presentation/ticker_state.dart';

import '../helpers/fixtures.dart';

class MockRepo extends Mock implements MarketRepository {}

void main() {
  late MockRepo repo;
  setUpAll(() => registerFallbackValue(ChartRange.d1));
  setUp(() => repo = MockRepo());

  test('처음 열면 종목 정보와 1일 차트', () async {
    when(() => repo.ticker('rtx-5070-ti')).thenAnswer((_) async => tickerFixture());
    when(() => repo.chart('rtx-5070-ti', ChartRange.d1)).thenAnswer((_) async => chartFixture());
    final c = TickerCubit(repo, 'rtx-5070-ti');

    await c.load();

    expect(c.state.loading, isFalse);
    expect(c.state.detail!.ticker.name, 'RTX 5070 Ti');
    expect(c.state.chart!.range, ChartRange.d1);
  });

  test('정보가 실패하면 그 실패 종류를 알린다(바로 던지는 경우 포함)', () async {
    when(() => repo.ticker(any())).thenThrow(const NotFoundFailure());
    when(() => repo.chart(any(), any())).thenAnswer((_) async => chartFixture());
    final c = TickerCubit(repo, 'nope');

    await c.load();

    expect(c.state.failure, isA<NotFoundFailure>());
  });

  test('한 번 받은 기간은 다시 받지 않는다', () async {
    when(() => repo.ticker(any())).thenAnswer((_) async => tickerFixture());
    when(() => repo.chart(any(), any())).thenAnswer((i) async => chartFixture(i.positionalArguments[1] as ChartRange));
    final c = TickerCubit(repo, 'rtx-5070-ti');
    await c.load();

    await c.selectRange(ChartRange.w1);
    await c.selectRange(ChartRange.d1);
    await c.selectRange(ChartRange.w1);

    verify(() => repo.chart('rtx-5070-ti', ChartRange.w1)).called(1);
    verify(() => repo.chart('rtx-5070-ti', ChartRange.d1)).called(1);
    expect(c.state.range, ChartRange.w1);
  });

  test('다시 받으면 다른 기간의 옛 차트는 버리고, 그 기간을 누를 때 새로 받는다', () async {
    when(() => repo.ticker(any())).thenAnswer((_) async => tickerFixture());
    when(() => repo.chart(any(), any())).thenAnswer((i) async => chartFixture(i.positionalArguments[1] as ChartRange));
    final c = TickerCubit(repo, 'rtx-5070-ti');
    await c.load();
    await c.selectRange(ChartRange.w1);
    await c.selectRange(ChartRange.d1);

    await c.load(); // 앱으로 돌아옴

    expect(c.state.charts.keys, [ChartRange.d1]);
    await c.selectRange(ChartRange.w1);
    verify(() => repo.chart('rtx-5070-ti', ChartRange.w1)).called(2);
  });

  test('1주를 받는 사이 1달로 바꿔도 각 기간 차트가 제자리에 들어간다', () async {
    final week = Completer<ChartData>();
    when(() => repo.ticker(any())).thenAnswer((_) async => tickerFixture());
    when(() => repo.chart(any(), ChartRange.d1)).thenAnswer((_) async => chartFixture());
    when(() => repo.chart(any(), ChartRange.w1)).thenAnswer((_) => week.future);
    when(() => repo.chart(any(), ChartRange.m1)).thenAnswer((_) async => chartFixture(ChartRange.m1));
    final c = TickerCubit(repo, 'rtx-5070-ti');
    await c.load();

    final w = c.selectRange(ChartRange.w1);
    expect(c.state.chartPending, isTrue);
    await c.selectRange(ChartRange.m1);
    week.complete(chartFixture(ChartRange.w1));
    await w;

    expect(c.state.range, ChartRange.m1);
    expect(c.state.chart!.range, ChartRange.m1);
    expect(c.state.charts[ChartRange.w1]!.range, ChartRange.w1);
  });

  test('선·봉 바꾸기', () {
    final c = TickerCubit(repo, 'rtx-5070-ti');
    c.selectKind(ChartKind.candle);
    expect(c.state.kind, ChartKind.candle);
  });
}
