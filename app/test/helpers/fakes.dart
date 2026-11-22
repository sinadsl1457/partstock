// 테스트용 가짜: 푸시(권한·토큰을 마음대로), 저장소들(mocktail).
import 'dart:async';

import 'package:mocktail/mocktail.dart';
import 'package:partstock/core/push/push_service.dart';
import 'package:partstock/features/alerts/data/alerts_repository.dart';
import 'package:partstock/features/market/data/market_repository.dart';

class MockMarketRepo extends Mock implements MarketRepository {}

class MockAlertsRepo extends Mock implements AlertsRepository {}

class FakePush implements PushService {
  FakePush({this.supported = true, this.allow = true, this.initialToken = 'token-1'});

  @override
  final bool supported;
  final bool allow;
  final String? initialToken;
  final refresh = StreamController<String>.broadcast();
  final opened = StreamController<String>.broadcast();
  final incoming = StreamController<({String title, String body})>.broadcast();

  @override
  Future<bool> requestPermission() async => allow;

  @override
  Future<String?> token() async => initialToken;

  @override
  Stream<String> get tokenRefresh => refresh.stream;

  @override
  Stream<String> get openedTicker => opened.stream;

  @override
  Stream<({String title, String body})> get foreground => incoming.stream;
}
