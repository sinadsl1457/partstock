// 목표가 알림 모델(서버 alert/AlertService.Alert).
import 'package:freezed_annotation/freezed_annotation.dart';

part 'alert_models.freezed.dart';

enum AlertDirection {
  below('BELOW'),
  above('ABOVE');

  const AlertDirection(this.code);
  final String code;
}

@freezed
abstract class PriceAlert with _$PriceAlert {
  const factory PriceAlert({
    required int id,
    required String tickerKey,
    required String tickerName,
    required AlertDirection direction,
    required int targetCents,
    required DateTime createdAt,
    DateTime? firedAt,
    int? firedCents,
  }) = _PriceAlert;

  const PriceAlert._();

  bool get waiting => firedAt == null;

  factory PriceAlert.fromMap(Map<String, dynamic> m) => PriceAlert(
    id: (m['id'] as num).toInt(),
    tickerKey: m['tickerKey'] as String,
    tickerName: m['tickerName'] as String,
    direction: AlertDirection.values.firstWhere((d) => d.code == m['direction']),
    targetCents: (m['targetCents'] as num).toInt(),
    createdAt: DateTime.parse(m['createdAt'] as String),
    firedAt: m['firedAt'] == null ? null : DateTime.parse(m['firedAt'] as String),
    firedCents: (m['firedCents'] as num?)?.toInt(),
  );
}
