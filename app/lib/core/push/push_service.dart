// 푸시(FCM): 권한·기기 토큰·알림 누름. 테스트에서는 가짜로 바꿔 끼운다.
import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

abstract interface class PushService {
  /// 이 기기에서 알림을 쓸 수 있나. iOS는 Apple 유료 계정(APNs)이 없어 지금은 Android만.
  bool get supported;

  /// 권한을 묻고(Android 13+) 허용되면 true
  Future<bool> requestPermission();

  Future<String?> token();

  Stream<String> get tokenRefresh;

  /// 알림을 눌러 앱이 열렸을 때 그 종목 키(앱이 꺼져 있다가 열린 경우 포함)
  Stream<String> get openedTicker;

  /// 앱이 켜져 있는 동안 온 알림(제목·본문)
  Stream<({String title, String body})> get foreground;
}

@LazySingleton(as: PushService)
class FirebasePushService implements PushService {
  FirebaseMessaging get _fm => FirebaseMessaging.instance;

  @override
  bool get supported => defaultTargetPlatform == TargetPlatform.android;

  @override
  Future<bool> requestPermission() async {
    final s = await _fm.requestPermission();
    return s.authorizationStatus == AuthorizationStatus.authorized ||
        s.authorizationStatus == AuthorizationStatus.provisional;
  }

  // firebase_messaging 17.1부터 getToken·onTokenRefresh는 register()·onRegistered(설치 ID, FID)로 바뀌는 중.
  // 서버가 FID로 보내는 방법(HTTP v1 대상 모양)을 아직 확인하지 않아, 검증된 FCM 토큰 방식을 쓴다. CLAUDE.md 할 일 참고.
  @override
  // ignore: deprecated_member_use
  Future<String?> token() => _fm.getToken();

  @override
  // ignore: deprecated_member_use
  Stream<String> get tokenRefresh => _fm.onTokenRefresh;

  @override
  Stream<String> get openedTicker async* {
    final initial = await _fm.getInitialMessage();
    final key = initial?.data['tickerKey'];
    if (key is String) yield key;
    yield* FirebaseMessaging.onMessageOpenedApp
        .map((m) => m.data['tickerKey'])
        .where((k) => k is String)
        .cast<String>();
  }

  @override
  Stream<({String title, String body})> get foreground => FirebaseMessaging.onMessage
      .where((m) => m.notification != null)
      .map((m) => (title: m.notification!.title ?? '', body: m.notification!.body ?? ''));
}
