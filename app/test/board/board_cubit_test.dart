// 시세 목록: 저장된 목록을 먼저, 탭을 빨리 바꾸면 늦게 온 응답을 버린다.
import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:partstock/core/network/app_failure.dart';
import 'package:partstock/features/board/data/board_filter.dart';
import 'package:partstock/features/board/data/board_filter_repository.dart';
import 'package:partstock/features/board/presentation/board_cubit.dart';
import 'package:partstock/features/board/presentation/board_state.dart';
import 'package:partstock/features/market/data/market_models.dart';
import 'package:partstock/features/market/data/market_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/fixtures.dart';

class MockRepo extends Mock implements MarketRepository {}

void main() {
  late MockRepo repo;
  late BoardFilterRepository filters;
  final fresh = boardFixture();
  final old = fresh.copyWith(items: fresh.items.take(1).toList());

  setUpAll(() => registerFallbackValue(Category.gpu));
  setUp(() async {
    repo = MockRepo();
    SharedPreferences.setMockInitialValues({});
    filters = BoardFilterRepository(await SharedPreferences.getInstance());
  });

  blocTest<BoardCubit, BoardState>(
    '저장된 목록을 먼저 보여 주고 새로 받으면 바꾼다',
    build: () {
      when(() => repo.cachedBoard(Category.gpu)).thenReturn(old);
      when(() => repo.board(Category.gpu)).thenAnswer((_) async => fresh);
      return BoardCubit(repo, filters);
    },
    act: (c) => c.select(Category.gpu),
    expect: () => [
      BoardState(
        category: Category.gpu,
        board: old,
        fromCache: true,
        loading: true,
        filter: initialFilter(Category.gpu),
      ),
      BoardState(category: Category.gpu, board: fresh, filter: initialFilter(Category.gpu)),
    ],
  );

  blocTest<BoardCubit, BoardState>(
    '연결이 안 되면 저장된 목록은 두고 실패를 알린다',
    build: () {
      when(() => repo.cachedBoard(Category.gpu)).thenReturn(old);
      when(() => repo.board(Category.gpu)).thenThrow(const NetworkFailure());
      return BoardCubit(repo, filters);
    },
    act: (c) => c.select(Category.gpu),
    skip: 1,
    expect: () => [
      isA<BoardState>()
          .having((s) => s.board, 'board', old)
          .having((s) => s.fromCache, 'fromCache', true)
          .having((s) => s.failure, 'failure', isA<NetworkFailure>()),
    ],
  );

  test('받는 사이 다른 탭으로 바꾸면 늦게 온 그래픽카드 응답은 버린다', () async {
    final gpu = Completer<Board>();
    when(() => repo.cachedBoard(any())).thenReturn(null);
    when(() => repo.board(Category.gpu)).thenAnswer((_) => gpu.future);
    when(() => repo.board(Category.ram)).thenAnswer((_) async => old);
    final c = BoardCubit(repo, filters);

    final first = c.select(Category.gpu);
    await c.select(Category.ram);
    gpu.complete(fresh);
    await first;

    expect(c.state.category, Category.ram);
    expect(c.state.board, old);
  });

  test('고른 필터는 분류마다 저장돼 다시 열어도 남는다', () async {
    when(() => repo.cachedBoard(any())).thenReturn(null);
    when(() => repo.board(any())).thenAnswer((_) async => fresh);
    final first = BoardCubit(repo, filters);
    await first.select(Category.ram);
    expect(first.state.filter, {
      'ddr': <String>{},
      'pack': {'1'},
    });
    await first.setFilter({
      'ddr': {'DDR4'},
      'pack': {'2'},
    });
    await first.close();

    final again = BoardCubit(repo, filters);
    await again.select(Category.ram);
    expect(again.state.filter, {
      'ddr': {'DDR4'},
      'pack': {'2'},
    });
    await again.select(Category.gpu);
    expect(again.state.filter, {'series': <String>{}}); // VGA 필터는 따로
    await again.close();
  });
}
