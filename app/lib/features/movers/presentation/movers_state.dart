// 급등락 탭 상태.
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/network/app_failure.dart';
import '../../market/data/market_models.dart';

part 'movers_state.freezed.dart';

@freezed
abstract class MoversState with _$MoversState {
  const factory MoversState({Movers? movers, @Default(false) bool loading, AppFailure? failure}) = _MoversState;
}
