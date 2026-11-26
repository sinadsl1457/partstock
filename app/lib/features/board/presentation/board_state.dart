// 시세 목록 탭 상태. 네 분류(VGA/RAM/CPU/SSD)를 한꺼번에 받아 같이 들고 있다.
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/network/app_failure.dart';
import '../../market/data/market_models.dart';

part 'board_state.freezed.dart';

@freezed
abstract class BoardState with _$BoardState {
  const BoardState._();

  const factory BoardState({
    @Default(Category.gpu) Category category,

    /// 분류 대신 급등락 탭을 보고 있다(내용은 MoversCubit)
    @Default(false) bool movers,

    /// 분류마다 받은(또는 저장해 둔) 시세 목록
    @Default({}) Map<Category, Board> boards,

    /// 지금 분류의 필터(저장소에서 읽음)
    @Default({}) Map<String, Set<String>> filter,
    @Default(false) bool loading,

    /// 지금 보이는 목록이 저장해 둔 것(새로 받기 전·실패)
    @Default(false) bool fromCache,
    AppFailure? failure,
  }) = _BoardState;

  /// 지금 분류의 목록
  Board? get board => boards[category];

  /// 네 분류를 같이 받으니 업데이트 시각도 하나다. 탭을 옮겨도 바뀌지 않는다.
  DateTime? get updatedAt {
    DateTime? latest;
    for (final b in boards.values) {
      final t = b.updatedAt;
      if (t != null && (latest == null || t.isAfter(latest))) latest = t;
    }
    return latest;
  }
}
