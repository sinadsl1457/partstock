// 시세 목록: 저장된 목록을 먼저, 탭을 빨리 바꾸면 늦게 온 응답을 버린다.
import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:partstock/core/network/app_failure.dart';
import 'package:partstock/features/board/presentation/board_cubit.dart';
import 'package:partstock/features/board/presentation/board_state.dart';
import 'package:partstock/features/market/data/market_models.dart';
import 'package:partstock/features/market/data/market_repository.dart';

import '../helpers/fixtures.dart';

class MockRepo extends Mock implements MarketRepository {}

void main() {
  late MockRepo repo;
  final fresh = boardFixture();
  final old = fresh.copyWith(items: fresh.items.take(1).toList());

  setUpAll(() => registerFallbackValue(Category.gpu));
  setUp(() => repo = MockRepo());

  blocTest<BoardCubit, BoardState>(
    '저장된 목록을 먼저 보여 주고 새로 받으면 바꾼다',
    build: () {
      when(() => repo.cachedBoard(Category.gpu)).thenReturn(old);
      when(() => repo.board(Category.gpu)).thenAnswer((_) async => fresh);
      return BoardCubit(repo);
    },
    act: (c) => c.select(Category.gpu),
    expect: () => [
      BoardState(category: Category.gpu, board: old, fromCache: true, loading: true),
      BoardState(category: Category.gpu, board: fresh),
    ],
  );

  blocTest<BoardCubit, BoardState>(
    '연결이 안 되면 저장된 목록은 두고 실패를 알린다',
    build: () {
      when(() => repo.cachedBoard(Category.gpu)).thenReturn(old);
      when(() => repo.board(Category.gpu)).thenThrow(const NetworkFailure());
      return BoardCubit(repo);
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
    final c = BoardCubit(repo);

    final first = c.select(Category.gpu);
    await c.select(Category.ram);
    gpu.complete(fresh);
    await first;

    expect(c.state.category, Category.ram);
    expect(c.state.board, old);
  });
}
