// 종목 차트 화면 상태. 기간별 차트는 한 번 받으면 기억한다(기간 버튼을 다시 눌러도 기다리지 않게).
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/network/app_failure.dart';
import '../../market/data/market_models.dart';

part 'ticker_state.freezed.dart';

enum ChartKind { line, candle }

@freezed
abstract class TickerState with _$TickerState {
  const factory TickerState({
    required String key,
    TickerDetail? detail,
    @Default({}) Map<ChartRange, ChartData> charts,
    @Default(ChartRange.d1) ChartRange range,
    @Default(ChartKind.line) ChartKind kind,
    @Default(true) bool loading,
    AppFailure? failure,
  }) = _TickerState;

  const TickerState._();

  ChartData? get chart => charts[range];

  /// 고른 기간의 차트를 받는 중
  bool get chartPending => chart == null && !loading && failure == null;
}
