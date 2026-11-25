// 시세 목록: 탭(VGA/RAM/CPU/SSD)을 고르면 저장된 목록을 먼저 보여 주고 새로 받는다. 탭마다 고른 필터를 기억한다.
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../core/network/app_failure.dart';
import '../../market/data/market_models.dart';
import '../data/board_filter.dart';
import '../data/board_filter_repository.dart';
import '../../market/data/market_repository.dart';
import 'board_state.dart';

@injectable
class BoardCubit extends Cubit<BoardState> {
  BoardCubit(this._repo, this._filters) : super(const BoardState());

  final MarketRepository _repo;
  final BoardFilterRepository _filters;

  Future<void> select(Category category) async {
    final cached = _repo.cachedBoard(category);
    emit(
      BoardState(
        category: category,
        board: cached,
        fromCache: cached != null,
        loading: true,
        filter: _filters.load(category),
      ),
    );
    await _fetch(category);
  }

  /// 옆 탭을 밀어서 보는 동안 미리 보여 줄 저장된 목록과 그 탭의 필터(상태는 바꾸지 않는다)
  ({Board? board, BoardFilter filter}) peek(Category category) =>
      (board: _repo.cachedBoard(category), filter: _filters.load(category));

  /// 급등락 탭으로. 지금 분류 목록은 그대로 두고 돌아오면 다시 보인다
  void showMovers() => emit(state.copyWith(movers: true));

  Future<void> setFilter(BoardFilter filter) async {
    emit(state.copyWith(filter: filter));
    await _filters.save(state.category, filter);
  }

  Future<void> refresh() async {
    emit(state.copyWith(loading: true, failure: null));
    await _fetch(state.category);
  }

  Future<void> _fetch(Category category) async {
    try {
      final board = await _repo.board(category);
      // 받는 동안 다른 탭으로 바꿨으면 늦게 온 응답은 버린다
      if (isClosed || state.category != category) return;
      emit(state.copyWith(board: board, loading: false, fromCache: false, failure: null));
    } on AppFailure catch (f) {
      if (isClosed || state.category != category) return;
      emit(state.copyWith(loading: false, failure: f));
    }
  }
}
