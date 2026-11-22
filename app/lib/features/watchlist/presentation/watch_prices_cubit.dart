// 관심 탭 화면의 현재가 받기(탭 화면과 함께 산다). 키 목록은 WatchlistCubit이 갖고, 바뀌면 화면이 load를 부른다.
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../core/network/app_failure.dart';
import '../../market/data/market_repository.dart';
import 'watch_prices_state.dart';

@injectable
class WatchPricesCubit extends Cubit<WatchPricesState> {
  WatchPricesCubit(this._repo) : super(const WatchPricesState());

  final MarketRepository _repo;
  int _generation = 0;

  Future<void> load(List<String> keys) async {
    final gen = ++_generation;
    emit(state.copyWith(loading: true, failure: null));
    try {
      final details = await Future.wait(keys.map(_repo.ticker));
      // 받는 사이 목록이 또 바뀌었으면 이번 결과는 버린다
      if (isClosed || gen != _generation) return;
      emit(WatchPricesState(details: {for (final d in details) d.ticker.key: d}));
    } on AppFailure catch (f) {
      if (isClosed || gen != _generation) return;
      emit(state.copyWith(loading: false, failure: f));
    }
  }
}
