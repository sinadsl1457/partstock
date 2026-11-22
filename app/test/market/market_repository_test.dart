// 저장소: 실제 API 응답 예시(test/fixtures, 2026-11-22 배포 서버에서 받음)를 읽고, 시세 목록을 저장해 두는지.
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:partstock/core/network/api_client.dart';
import 'package:partstock/core/network/app_failure.dart';
import 'package:partstock/features/market/data/market_models.dart';
import 'package:partstock/features/market/data/market_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

String fixture(String name) => File('test/fixtures/$name.json').readAsStringSync();

void main() {
  late SharedPreferences prefs;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
  });

  MarketRepository repo(MockClientHandler handler) =>
      MarketRepository(ApiClient(MockClient(handler), 'https://api.test'), prefs);

  test('시세 목록을 읽고 마지막 응답을 저장한다', () async {
    final r = repo((req) async {
      expect(req.url.toString(), 'https://api.test/api/board?category=GPU');
      return http.Response.bytes(utf8.encode(fixture('board_gpu')), 200);
    });

    final board = await r.board(Category.gpu);

    expect(board.items.first.key, 'rtx-5090');
    final ti = board.items.firstWhere((i) => i.key == 'rtx-5070-ti');
    expect(ti.vendor, 'NVIDIA');
    expect(ti.price!.p25Cents, greaterThan(0));
    expect(ti.spark, isNotEmpty);
    expect(ti.links.ebay, startsWith('https://www.ebay.com/sch/'));
    expect(board.fx!.usdKrw, greaterThan(1000));
    expect(r.cachedBoard(Category.gpu)!.items.length, board.items.length);
    expect(r.cachedBoard(Category.ram), isNull);
  });

  test('종목 상세와 차트를 읽는다', () async {
    final r = repo((req) async {
      final body = req.url.path == '/api/ticker' ? fixture('ticker_rtx5070ti') : fixture('chart_1d');
      return http.Response.bytes(utf8.encode(body), 200);
    });

    final d = await r.ticker('rtx-5070-ti');
    expect(d.ticker.name, 'RTX 5070 Ti');
    expect(d.ticker.level, 'CHIPSET');
    expect(d.makers, isNotEmpty);

    final c = await r.chart('rtx-5070-ti', ChartRange.d1);
    expect(c.range, ChartRange.d1);
    expect(c.bucket, '1 hour');
    expect(c.bars, isNotEmpty);
    expect(c.since, isNotNull);
  });

  test('연결 실패와 서버 오류와 없는 종목을 나눈다', () async {
    expect(
      repo((_) async => throw http.ClientException('no route')).board(Category.gpu),
      throwsA(isA<NetworkFailure>()),
    );
    expect(
      repo((_) async => http.Response('boom', 502)).board(Category.gpu),
      throwsA(isA<ServerFailure>().having((f) => f.status, 'status', 502)),
    );
    expect(repo((_) async => http.Response('', 404)).ticker('nope'), throwsA(isA<NotFoundFailure>()));
  });

  test('저장해 둔 응답 모양이 깨졌으면 없는 것으로 본다', () async {
    await prefs.setString('cache.board.GPU', '{"broken":');
    expect(repo((_) async => http.Response('', 500)).cachedBoard(Category.gpu), isNull);
  });
}
