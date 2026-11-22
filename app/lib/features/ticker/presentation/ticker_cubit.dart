// 종목 차트: 종목 정보와 고른 기간의 차트를 받는다. 종목을 열 때 생기고 닫으면 사라진다.
import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../core/network/app_failure.dart';
import '../../market/data/market_models.dart';
import '../../market/data/market_repository.dart';
import 'ticker_state.dart';

@injectable
class TickerCubit extends Cubit<TickerState> {
  TickerCubit(this._repo, @factoryParam String key) : super(TickerState(key: key));

  final MarketRepository _repo;

  Future<void> load() async {
    emit(state.copyWith(loading: true, failure: null));
    try {
      final (detail, chart) = await (_repo.ticker(state.key), _repo.chart(state.key, state.range)).wait;
      if (isClosed) return;
      emit(state.copyWith(detail: detail, charts: {...state.charts, chart.range: chart}, loading: false));
    } on ParallelWaitError<(TickerDetail?, ChartData?), (AsyncError?, AsyncError?)> catch (e) {
      if (isClosed) return;
      emit(state.copyWith(loading: false, failure: _failure(e.errors.$1 ?? e.errors.$2)));
    } on AppFailure catch (f) {
      // 기다리기 전에 바로 실패한 경우(호출 자체가 던짐)
      if (isClosed) return;
      emit(state.copyWith(loading: false, failure: f));
    }
  }

  Future<void> selectRange(ChartRange range) async {
    emit(state.copyWith(range: range, failure: null));
    if (state.charts.containsKey(range)) return;
    try {
      final chart = await _repo.chart(state.key, range);
      if (isClosed) return;
      // 기간별로 따로 기억해서, 받는 사이 다른 기간을 눌러도 섞이지 않는다
      emit(state.copyWith(charts: {...state.charts, range: chart}));
    } on AppFailure catch (f) {
      if (isClosed || state.range != range) return;
      emit(state.copyWith(failure: f));
    }
  }

  void selectKind(ChartKind kind) => emit(state.copyWith(kind: kind));

  static AppFailure _failure(AsyncError? e) => e?.error is AppFailure ? e!.error as AppFailure : const ServerFailure(0);
}
