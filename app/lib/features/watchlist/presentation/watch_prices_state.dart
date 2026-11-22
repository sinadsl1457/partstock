// 관심 탭에 보일 종목별 현재가.
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/network/app_failure.dart';
import '../../market/data/market_models.dart';

part 'watch_prices_state.freezed.dart';

@freezed
abstract class WatchPricesState with _$WatchPricesState {
  const factory WatchPricesState({
    @Default({}) Map<String, TickerDetail> details,
    @Default(false) bool loading,
    AppFailure? failure,
  }) = _WatchPricesState;
}
