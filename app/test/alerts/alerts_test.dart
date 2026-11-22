// 목표가 알림: 권한·등록 흐름, 걸기·지우기, 만원 ↔ 센트.
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:partstock/core/network/app_failure.dart';
import 'package:partstock/features/alerts/data/alert_models.dart';
import 'package:partstock/features/alerts/presentation/alert_sheet.dart';
import 'package:partstock/features/alerts/presentation/alerts_cubit.dart';
import 'package:partstock/features/alerts/presentation/alerts_state.dart';

import '../helpers/fakes.dart';

PriceAlert alert(int id, {String key = 'rtx-5070-ti', DateTime? firedAt}) => PriceAlert(
  id: id,
  tickerKey: key,
  tickerName: 'RTX 5070 Ti',
  direction: AlertDirection.below,
  targetCents: 140000,
  createdAt: DateTime.utc(2026, 11, 22),
  firedAt: firedAt,
);

void main() {
  late MockAlertsRepo repo;
  setUpAll(() => registerFallbackValue(AlertDirection.below));
  setUp(() {
    repo = MockAlertsRepo();
    when(
      () => repo.registerDevice(
        any(),
        platform: any(named: 'platform'),
        locale: any(named: 'locale'),
      ),
    ).thenAnswer((_) async {});
    when(() => repo.list(any())).thenAnswer((_) async => [alert(1)]);
  });

  test('iOS(지원 안 함)면 권한도 안 묻고 멈춘다', () async {
    final c = AlertsCubit(FakePush(supported: false), repo);
    await c.start('ko');
    expect(c.state.status, AlertsStatus.unsupported);
    verifyNever(
      () => repo.registerDevice(
        any(),
        platform: any(named: 'platform'),
        locale: any(named: 'locale'),
      ),
    );
  });

  test('권한을 거절하면 denied', () async {
    final c = AlertsCubit(FakePush(allow: false), repo);
    await c.start('ko');
    expect(c.state.status, AlertsStatus.denied);
  });

  test('허락하면 기기를 등록하고 내 알림을 받는다, 토큰이 바뀌면 다시 등록', () async {
    final push = FakePush();
    final c = AlertsCubit(push, repo);
    await c.start('en');

    expect(c.state.status, AlertsStatus.ready);
    expect(c.state.alerts.single.id, 1);
    verify(() => repo.registerDevice('token-1', platform: 'ANDROID', locale: 'en')).called(1);

    push.refresh.add('token-2');
    await Future<void>.delayed(Duration.zero);
    verify(() => repo.registerDevice('token-2', platform: 'ANDROID', locale: 'en')).called(1);
    expect(c.state.token, 'token-2');
  });

  test('등록이 실패하면 준비 중으로 남고 다시 시도하면 된다', () async {
    var fail = true;
    when(
      () => repo.registerDevice(
        any(),
        platform: any(named: 'platform'),
        locale: any(named: 'locale'),
      ),
    ).thenAnswer((_) async {
      if (fail) throw const NetworkFailure();
    });
    final c = AlertsCubit(FakePush(), repo);
    await c.start('ko');
    expect(c.state.status, AlertsStatus.starting);
    expect(c.state.failure, isA<NetworkFailure>());

    fail = false;
    await c.reload();
    expect(c.state.status, AlertsStatus.ready);
  });

  test('걸면 맨 앞에, 지우면 빠지고, 20개 넘으면 실패를 돌려준다', () async {
    when(() => repo.create(any(), any(), any(), any())).thenAnswer((_) async => alert(2));
    when(() => repo.delete(any(), any())).thenAnswer((_) async {});
    final c = AlertsCubit(FakePush(), repo);
    await c.start('ko');

    expect(await c.create('rtx-5070-ti', AlertDirection.below, 140000), isNull);
    expect(c.state.alerts.map((a) => a.id), [2, 1]);
    expect(c.state.waitingFor('rtx-5070-ti').length, 2);

    expect(await c.delete(1), isNull);
    expect(c.state.alerts.map((a) => a.id), [2]);

    when(() => repo.create(any(), any(), any(), any())).thenThrow(const ServerFailure(409));
    expect(await c.create('rtx-5090', AlertDirection.below, 1), isA<ServerFailure>());
  });

  test('울린 알림은 대기 중으로 세지 않는다', () {
    final s = AlertsState(
      alerts: [
        alert(1),
        alert(2, firedAt: DateTime.utc(2026, 11, 23)),
      ],
    );
    expect(s.waitingFor('rtx-5070-ti').map((a) => a.id), [1]);
  });

  test('만원 ↔ 센트: 1,300원이면 182.0만원 = 140,000센트', () {
    const ko = AlertUnits(1300);
    expect(ko.toCents(182.0), 140000);
    expect(ko.text(ko.fromCents(140000)), '182.0');
    const en = AlertUnits(null);
    expect(en.toCents(1400), 140000);
    expect(en.text(en.fromCents(139999)), '1400');
  });
}
