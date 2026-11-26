// 시세 목록: 네 분류를 한꺼번에 받고, 저장된 목록을 먼저, 탭을 바꿔도 다시 받지 않는다.
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
  final fresh = {
    Category.gpu: boardFixture(),
    Category.ram: boardFixture('board_ram'),
    Category.cpu: boardFixture('board_cpu'),
    Category.ssd: boardFixture('board_ssd'),
  };
  final old = {for (final e in fresh.entries) e.key: e.value.copyWith(items: e.value.items.take(1).toList())};

  setUpAll(() => registerFallbackValue(Category.gpu));
  setUp(() async {
    repo = MockRepo();
    SharedPreferences.setMockInitialValues({});
    filters = BoardFilterRepository(await SharedPreferences.getInstance());
  });

  void answerFresh() => when(() => repo.board(any())).thenAnswer((i) async => fresh[i.positionalArguments[0]]!);

  blocTest<BoardCubit, BoardState>(
    '저장된 네 분류를 먼저 보여 주고, 한꺼번에 새로 받으면 바꾼다',
    build: () {
      when(() => repo.cachedBoard(any())).thenAnswer((i) => old[i.positionalArguments[0]]);
      answerFresh();
      return BoardCubit(repo, filters);
    },
    act: (c) => c.start(),
    expect: () => [
      BoardState(boards: old, fromCache: true, loading: true, filter: initialFilter(Category.gpu)),
      BoardState(boards: fresh, filter: initialFilter(Category.gpu)),
    ],
    verify: (_) {
      for (final c in Category.values) {
        verify(() => repo.board(c)).called(1);
      }
    },
  );

  blocTest<BoardCubit, BoardState>(
    '한 분류라도 실패하면 저장된 목록을 그대로 두고 실패를 알린다(다른 시각의 시세가 섞이지 않게)',
    build: () {
      when(() => repo.cachedBoard(any())).thenAnswer((i) => old[i.positionalArguments[0]]);
      answerFresh();
      when(() => repo.board(Category.ssd)).thenThrow(const NetworkFailure());
      return BoardCubit(repo, filters);
    },
    act: (c) => c.start(),
    skip: 1,
    expect: () => [
      isA<BoardState>()
          .having((s) => s.boards, 'boards', old)
          .having((s) => s.fromCache, 'fromCache', true)
          .having((s) => s.loading, 'loading', false)
          .having((s) => s.failure, 'failure', isA<NetworkFailure>()),
    ],
  );

  test('탭을 바꾸면 받아 둔 목록을 보여 줄 뿐 다시 받지 않고, 업데이트 시각도 그대로다', () async {
    when(() => repo.cachedBoard(any())).thenReturn(null);
    answerFresh();
    final c = BoardCubit(repo, filters);
    await c.start();
    final updated = c.state.updatedAt;
    expect(updated, DateTime.utc(2026, 11, 22, 5)); // 네 분류 중 가장 최근(RAM)

    for (final cat in Category.values) {
      c.select(cat);
      expect(c.state.board, fresh[cat]);
      expect(c.state.updatedAt, updated);
    }
    verify(() => repo.board(any())).called(4);
    await c.close();
  });

  test('받는 사이 또 새로 받으라고 하면 같은 요청을 기다린다(분류마다 한 번만)', () async {
    final gpu = Completer<Board>();
    when(() => repo.cachedBoard(any())).thenReturn(null);
    answerFresh();
    when(() => repo.board(Category.gpu)).thenAnswer((_) => gpu.future);
    final c = BoardCubit(repo, filters);

    final first = c.start();
    final second = c.refresh();
    gpu.complete(fresh[Category.gpu]);
    await Future.wait([first, second]);

    verify(() => repo.board(any())).called(4);
    expect(c.state.boards, fresh);
    await c.close();
  });

  test('고른 필터는 분류마다 저장돼 다시 열어도 남는다', () async {
    when(() => repo.cachedBoard(any())).thenReturn(null);
    answerFresh();
    final first = BoardCubit(repo, filters);
    await first.start();
    first.select(Category.ram);
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
    await again.start();
    again.select(Category.ram);
    expect(again.state.filter, {
      'ddr': {'DDR4'},
      'pack': {'2'},
    });
    again.select(Category.gpu);
    expect(again.state.filter, {'series': <String>{}}); // VGA 필터는 따로
    await again.close();
  });
}
