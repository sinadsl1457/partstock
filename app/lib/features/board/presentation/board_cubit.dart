// 시세 목록: 네 분류(VGA/RAM/CPU/SSD)를 한꺼번에 받는다. 저장된 목록을 먼저 보여 주고 새로 받는다.
// 탭을 바꿀 때는 다시 받지 않는다(업데이트 시각이 탭마다 바뀌어 보이지 않게). 탭마다 고른 필터를 기억한다.
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

  /// 받는 중인 새로 받기. 받는 사이 또 부르면(당기기·앱으로 돌아옴) 같은 요청을 기다린다.
  Future<void>? _inflight;

  /// 시세 탭을 열 때 한 번(라우트가 부름): 저장된 네 분류를 먼저 보여 주고 한꺼번에 새로 받는다.
  Future<void> start() {
    final cached = <Category, Board>{for (final c in Category.values) c: ?_repo.cachedBoard(c)};
    emit(
      BoardState(
        category: state.category,
        boards: cached,
        fromCache: cached.isNotEmpty,
        loading: true,
        filter: _filters.load(state.category),
      ),
    );
    return refresh();
  }

  /// 탭 바꾸기. 이미 받은 목록을 보여 줄 뿐 받지 않는다.
  void select(Category category) =>
      emit(state.copyWith(category: category, movers: false, filter: _filters.load(category)));

  /// 옆 탭을 밀어서 보는 동안 미리 보여 줄 목록과 그 탭의 필터(상태는 바꾸지 않는다)
  ({Board? board, BoardFilter filter}) peek(Category category) =>
      (board: state.boards[category], filter: _filters.load(category));

  /// 급등락 탭으로. 지금 분류 목록은 그대로 두고 돌아오면 다시 보인다
  void showMovers() => emit(state.copyWith(movers: true));

  Future<void> setFilter(BoardFilter filter) async {
    emit(state.copyWith(filter: filter));
    await _filters.save(state.category, filter);
  }

  /// 네 분류를 한꺼번에 새로 받는다(시작·당기기·앱으로 돌아옴).
  Future<void> refresh() => _inflight ??= _fetchAll().whenComplete(() => _inflight = null);

  Future<void> _fetchAll() async {
    emit(state.copyWith(loading: true, failure: null));
    try {
      // 하나라도 실패하면 저장된 목록을 그대로 둔다(분류마다 다른 시각의 시세가 섞이지 않게)
      final boards = await Future.wait([for (final c in Category.values) _repo.board(c)]);
      if (isClosed) return;
      emit(
        state.copyWith(
          boards: {for (var i = 0; i < boards.length; i++) Category.values[i]: boards[i]},
          loading: false,
          fromCache: false,
          failure: null,
        ),
      );
    } on AppFailure catch (f) {
      if (isClosed) return;
      emit(state.copyWith(loading: false, failure: f));
    }
  }
}
