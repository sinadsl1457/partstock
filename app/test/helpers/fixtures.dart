// 테스트용 모델: 실제 API 응답 예시(test/fixtures)를 읽어 만든다.
import 'dart:convert';
import 'dart:io';

import 'package:partstock/features/market/data/market_models.dart';

Map<String, dynamic> _json(String name) =>
    jsonDecode(File('test/fixtures/$name.json').readAsStringSync()) as Map<String, dynamic>;

Board boardFixture() => Board.fromMap(_json('board_gpu'));
TickerDetail tickerFixture() => TickerDetail.fromMap(_json('ticker_rtx5070ti'));
ChartData chartFixture([ChartRange range = ChartRange.d1]) =>
    ChartData.fromMap({..._json('chart_1d'), 'range': range.code});
