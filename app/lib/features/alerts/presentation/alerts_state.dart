// 목표가 알림 상태(앱 전체).
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/network/app_failure.dart';
import '../data/alert_models.dart';

part 'alerts_state.freezed.dart';

enum AlertsStatus {
  /// 이 기기에서 못 씀(iOS)
  unsupported,

  /// 알림 권한 거절
  denied,

  /// 아직 준비 중(권한·토큰·등록)
  starting,
  ready,
}

@freezed
abstract class AlertsState with _$AlertsState {
  const factory AlertsState({
    @Default(AlertsStatus.starting) AlertsStatus status,
    String? token,
    @Default([]) List<PriceAlert> alerts,
    AppFailure? failure,
  }) = _AlertsState;

  const AlertsState._();

  List<PriceAlert> waitingFor(String tickerKey) => alerts.where((a) => a.tickerKey == tickerKey && a.waiting).toList();
}
