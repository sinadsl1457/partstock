// 시세 목록 탭 상태.
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/network/app_failure.dart';
import '../../market/data/market_models.dart';

part 'board_state.freezed.dart';

@freezed
abstract class BoardState with _$BoardState {
  const factory BoardState({
    @Default(Category.gpu) Category category,

    /// 분류 대신 급등락 탭을 보고 있다(내용은 MoversCubit)
    @Default(false) bool movers,
    Board? board,

    /// 지금 분류의 필터(저장소에서 읽음)
    @Default({}) Map<String, Set<String>> filter,
    @Default(false) bool loading,

    /// 지금 보이는 board가 저장해 둔 것(새로 받기 전·실패)
    @Default(false) bool fromCache,
    AppFailure? failure,
  }) = _BoardState;
}
