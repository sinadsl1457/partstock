// 시세 API 응답 모델. JSON은 fromMap으로 손으로 옮긴다(서버 응답 모양: server/api/ApiDtos.java).
// 가격은 모두 USD 센트 정수, 원화는 화면이 fx.usdKrw를 곱한다.
import 'package:freezed_annotation/freezed_annotation.dart';

part 'market_models.freezed.dart';

enum Category {
  gpu('GPU'),
  ram('RAM'),
  cpu('CPU');

  const Category(this.code);
  final String code;
}

enum ChartRange {
  d1('1d'),
  w1('1w'),
  m1('1m'),
  m3('3m'),
  y1('1y'),
  all('all');

  const ChartRange(this.code);
  final String code;
}

DateTime? _time(Object? v) => v == null ? null : DateTime.parse(v as String);
int _int(Object? v) => (v as num).toInt();
List<Map<String, dynamic>> _list(Object? v) => (v as List).cast<Map<String, dynamic>>();

@freezed
abstract class Fx with _$Fx {
  const factory Fx({required String day, required double usdKrw}) = _Fx;

  factory Fx.fromMap(Map<String, dynamic> m) => Fx(day: m['day'] as String, usdKrw: (m['usdKrw'] as num).toDouble());
}

@freezed
abstract class Price with _$Price {
  const factory Price({
    required int p25Cents,
    required int medianCents,
    required int p75Cents,
    required int listingCount,
  }) = _Price;

  factory Price.fromMap(Map<String, dynamic> m) => Price(
    p25Cents: _int(m['p25Cents']),
    medianCents: _int(m['medianCents']),
    p75Cents: _int(m['p75Cents']),
    listingCount: _int(m['listingCount']),
  );
}

/// 24시간 변동(24시간 전 또는 그 전 가장 가까운 시세 대비)
@freezed
abstract class Change with _$Change {
  const factory Change({required DateTime prevAt, required int prevP25Cents, required double pct}) = _Change;

  factory Change.fromMap(Map<String, dynamic> m) => Change(
    prevAt: DateTime.parse(m['prevAt'] as String),
    prevP25Cents: _int(m['prevP25Cents']),
    pct: (m['pct'] as num).toDouble(),
  );
}

@freezed
abstract class Links with _$Links {
  const factory Links({required String ebay, required String danawa}) = _Links;

  factory Links.fromMap(Map<String, dynamic> m) => Links(ebay: m['ebay'] as String, danawa: m['danawa'] as String);
}

@freezed
abstract class SparkPoint with _$SparkPoint {
  const factory SparkPoint({required DateTime t, required int p25Cents}) = _SparkPoint;

  factory SparkPoint.fromMap(Map<String, dynamic> m) =>
      SparkPoint(t: DateTime.parse(m['t'] as String), p25Cents: _int(m['p25Cents']));
}

@freezed
abstract class BoardItem with _$BoardItem {
  const factory BoardItem({
    required String key,
    required String name,

    /// NVIDIA | AMD | DESKTOP (화면 글자는 앱이 번역)
    required String vendor,

    /// 필터용 분류. GPU {series: RTX50}, RAM {ddr: DDR5, pack: 1|2}. 옛 응답(저장본)에는 없어서 빈 값
    @Default({}) Map<String, String> facets,
    Price? price,
    Change? change,
    required List<SparkPoint> spark,
    required Links links,
  }) = _BoardItem;

  factory BoardItem.fromMap(Map<String, dynamic> m) => BoardItem(
    key: m['key'] as String,
    name: m['name'] as String,
    vendor: m['vendor'] as String,
    facets: (m['facets'] as Map<String, dynamic>? ?? const {}).cast<String, String>(),
    price: m['price'] == null ? null : Price.fromMap(m['price'] as Map<String, dynamic>),
    change: m['change'] == null ? null : Change.fromMap(m['change'] as Map<String, dynamic>),
    spark: _list(m['spark']).map(SparkPoint.fromMap).toList(),
    links: Links.fromMap(m['links'] as Map<String, dynamic>),
  );
}

@freezed
abstract class Board with _$Board {
  const factory Board({required String category, DateTime? updatedAt, Fx? fx, required List<BoardItem> items}) = _Board;

  factory Board.fromMap(Map<String, dynamic> m) => Board(
    category: m['category'] as String,
    updatedAt: _time(m['updatedAt']),
    fx: m['fx'] == null ? null : Fx.fromMap(m['fx'] as Map<String, dynamic>),
    items: _list(m['items']).map(BoardItem.fromMap).toList(),
  );
}

@freezed
abstract class TickerInfo with _$TickerInfo {
  const factory TickerInfo({
    required String key,

    /// CHIPSET | MAKER | MODEL
    required String level,
    required String category,
    required String name,
    required String chipsetName,
    String? makerName,
    String? seriesName,
  }) = _TickerInfo;

  factory TickerInfo.fromMap(Map<String, dynamic> m) => TickerInfo(
    key: m['key'] as String,
    level: m['level'] as String,
    category: m['category'] as String,
    name: m['name'] as String,
    chipsetName: m['chipsetName'] as String,
    makerName: m['makerName'] as String?,
    seriesName: m['seriesName'] as String?,
  );
}

/// 종목 아래 제조사·모델 한 줄
@freezed
abstract class Child with _$Child {
  const factory Child({
    required String key,
    required String level,
    required String name,
    Price? price,
    Change? change,
    required Links links,
  }) = _Child;

  factory Child.fromMap(Map<String, dynamic> m) => Child(
    key: m['key'] as String,
    level: m['level'] as String,
    name: m['name'] as String,
    price: m['price'] == null ? null : Price.fromMap(m['price'] as Map<String, dynamic>),
    change: m['change'] == null ? null : Change.fromMap(m['change'] as Map<String, dynamic>),
    links: Links.fromMap(m['links'] as Map<String, dynamic>),
  );
}

@freezed
abstract class TickerDetail with _$TickerDetail {
  const factory TickerDetail({
    required TickerInfo ticker,
    DateTime? updatedAt,
    Fx? fx,
    Price? price,
    Change? change,
    required List<Child> makers,
    required List<Child> models,
    required Links links,
  }) = _TickerDetail;

  factory TickerDetail.fromMap(Map<String, dynamic> m) => TickerDetail(
    ticker: TickerInfo.fromMap(m['ticker'] as Map<String, dynamic>),
    updatedAt: _time(m['updatedAt']),
    fx: m['fx'] == null ? null : Fx.fromMap(m['fx'] as Map<String, dynamic>),
    price: m['price'] == null ? null : Price.fromMap(m['price'] as Map<String, dynamic>),
    change: m['change'] == null ? null : Change.fromMap(m['change'] as Map<String, dynamic>),
    makers: _list(m['makers']).map(Child.fromMap).toList(),
    models: _list(m['models']).map(Child.fromMap).toList(),
    links: Links.fromMap(m['links'] as Map<String, dynamic>),
  );
}

/// 봉 하나. 선 차트는 closeCents를 잇는다.
@freezed
abstract class Bar with _$Bar {
  const factory Bar({
    required DateTime t,
    required int openCents,
    required int highCents,
    required int lowCents,
    required int closeCents,
    required int medianCents,
    required int samples,
  }) = _Bar;

  factory Bar.fromMap(Map<String, dynamic> m) => Bar(
    t: DateTime.parse(m['t'] as String),
    openCents: _int(m['openCents']),
    highCents: _int(m['highCents']),
    lowCents: _int(m['lowCents']),
    closeCents: _int(m['closeCents']),
    medianCents: _int(m['medianCents']),
    samples: _int(m['samples']),
  );
}

@freezed
abstract class ChartData with _$ChartData {
  const factory ChartData({
    required String key,
    required ChartRange range,

    /// '1 hour' | '4 hours' | '1 day' | '7 days'
    required String bucket,
    required List<Bar> bars,
    double? rangePct,

    /// 처음 수집한 시각, 쌓인 매시간 시세 수
    DateTime? since,
    required int points,
  }) = _ChartData;

  factory ChartData.fromMap(Map<String, dynamic> m) => ChartData(
    key: m['key'] as String,
    range: ChartRange.values.firstWhere((r) => r.code == m['range']),
    bucket: m['bucket'] as String,
    bars: _list(m['bars']).map(Bar.fromMap).toList(),
    rangePct: (m['rangePct'] as num?)?.toDouble(),
    since: _time(m['since']),
    points: _int(m['points']),
  );
}
