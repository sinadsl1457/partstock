// 시세 목록: 탭(그래픽카드/램)을 고르면 저장된 목록을 먼저 보여 주고 새로 받는다.
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../core/network/app_failure.dart';
import '../../market/data/market_models.dart';
import '../../market/data/market_repository.dart';
import 'board_state.dart';

@injectable
class BoardCubit extends Cubit<BoardState> {
  BoardCubit(this._repo) : super(const BoardState());

  final MarketRepository _repo;

  Future<void> select(Category category) async {
    final cached = _repo.cachedBoard(category);
    emit(BoardState(category: category, board: cached, fromCache: cached != null, loading: true));
    await _fetch(category);
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
