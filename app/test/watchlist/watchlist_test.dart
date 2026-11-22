// 관심 종목: 별을 누르면 넣고 빼고 폰에 저장, 현재가는 목록이 바뀌는 사이 늦은 응답을 버린다.
import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:partstock/features/market/data/market_models.dart';
import 'package:partstock/features/market/data/market_repository.dart';
import 'package:partstock/features/watchlist/data/watchlist_repository.dart';
import 'package:partstock/features/watchlist/presentation/watch_prices_cubit.dart';
import 'package:partstock/features/watchlist/presentation/watchlist_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/fixtures.dart';

class MockRepo extends Mock implements MarketRepository {}

void main() {
  test('별을 누르면 넣고, 다시 누르면 빼고, 다시 켜도 남아 있다', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final c = WatchlistCubit(WatchlistRepository(prefs));

    await c.toggle('rtx-5070-ti');
    await c.toggle('ddr5-32gb');
    await c.toggle('rtx-5070-ti');

    expect(c.state, ['ddr5-32gb']);
    expect(WatchlistCubit(WatchlistRepository(prefs)).state, ['ddr5-32gb']);
  });

  test('관심 목록이 바뀌는 사이 늦게 온 현재가는 버린다', () async {
    final repo = MockRepo();
    final slow = Completer<TickerDetail>();
    final d = tickerFixture();
    when(() => repo.ticker('old')).thenAnswer((_) => slow.future);
    when(() => repo.ticker('rtx-5070-ti')).thenAnswer((_) async => d);
    final c = WatchPricesCubit(repo);

    final first = c.load(['old']);
    await c.load(['rtx-5070-ti']);
    slow.complete(d.copyWith(ticker: d.ticker.copyWith(key: 'old')));
    await first;

    expect(c.state.details.keys, ['rtx-5070-ti']);
    expect(c.state.loading, isFalse);
  });
}
