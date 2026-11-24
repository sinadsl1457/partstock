// 급등락 탭: 4개 분류의 24시간 급등·급락 TOP 5를 받는다. 시세 탭 화면과 함께 살고, 급등락 탭을 열 때 받는다.
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../core/network/app_failure.dart';
import '../../market/data/market_repository.dart';
import 'movers_state.dart';

@injectable
class MoversCubit extends Cubit<MoversState> {
  MoversCubit(this._repo) : super(const MoversState());

  final MarketRepository _repo;

  /// 처음 열 때만 받는다(다시 받기는 당기기·앱으로 돌아옴)
  Future<void> open() async {
    if (state.movers != null || state.loading) return;
    await refresh();
  }

  Future<void> refresh() async {
    emit(state.copyWith(loading: true, failure: null));
    try {
      final movers = await _repo.movers();
      if (isClosed) return;
      emit(MoversState(movers: movers));
    } on AppFailure catch (f) {
      if (isClosed) return;
      emit(state.copyWith(loading: false, failure: f));
    }
  }
}
