// 목표가 알림(앱 전체 수명): 권한 → 기기 토큰 등록 → 내 알림 목록. 종목 차트의 종 버튼과 관심 탭이 같은 상태를 본다.
import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../core/network/app_failure.dart';
import '../../../core/push/push_service.dart';
import '../data/alert_models.dart';
import '../data/alerts_repository.dart';
import 'alerts_state.dart';

@lazySingleton
class AlertsCubit extends Cubit<AlertsState> {
  AlertsCubit(this._push, this._repo) : super(const AlertsState());

  final PushService _push;
  final AlertsRepository _repo;
  StreamSubscription<String>? _refresh;
  String _locale = 'ko';

  /// 앱이 켜질 때 한 번. locale은 알림 글자 언어(서버가 만든다).
  Future<void> start(String locale) async {
    _locale = locale;
    if (!_push.supported) {
      emit(state.copyWith(status: AlertsStatus.unsupported));
      return;
    }
    if (!await _push.requestPermission()) {
      emit(state.copyWith(status: AlertsStatus.denied));
      return;
    }
    final token = await _push.token();
    if (token == null) {
      emit(state.copyWith(status: AlertsStatus.denied));
      return;
    }
    await _register(token);
    // 토큰이 바뀌면 서버에 다시 등록(옛 토큰의 알림은 서버가 UNREGISTERED로 정리)
    _refresh ??= _push.tokenRefresh.listen(_register);
  }

  Future<void> _register(String token) async {
    try {
      await _repo.registerDevice(token, platform: 'ANDROID', locale: _locale);
      final alerts = await _repo.list(token);
      if (isClosed) return;
      emit(AlertsState(status: AlertsStatus.ready, token: token, alerts: alerts));
    } on AppFailure catch (f) {
      if (isClosed) return;
      // 등록이 안 돼도 토큰은 들고 있다가, 화면이 다시 시도하게
      emit(state.copyWith(token: token, failure: f));
    }
  }

  Future<void> reload() async {
    final token = state.token;
    if (token == null) return;
    await _register(token);
  }

  /// 성공하면 null, 실패하면 그 실패(화면이 안내)
  Future<AppFailure?> create(String tickerKey, AlertDirection direction, int targetCents) async {
    final token = state.token;
    if (token == null || state.status != AlertsStatus.ready) return const NetworkFailure();
    try {
      final a = await _repo.create(token, tickerKey, direction, targetCents);
      emit(state.copyWith(alerts: [a, ...state.alerts], failure: null));
      return null;
    } on AppFailure catch (f) {
      return f;
    }
  }

  Future<AppFailure?> delete(int id) async {
    final token = state.token;
    if (token == null) return const NetworkFailure();
    try {
      await _repo.delete(token, id);
      emit(state.copyWith(alerts: state.alerts.where((a) => a.id != id).toList()));
      return null;
    } on AppFailure catch (f) {
      return f;
    }
  }

  @override
  Future<void> close() async {
    await _refresh?.cancel();
    return super.close();
  }
}
