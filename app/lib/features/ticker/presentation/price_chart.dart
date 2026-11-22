// 종목 차트(선·봉). 한국어는 "지금 환율" 하나로 원화로 바꿔 그린다(환율 변동이 아니라 부품 가격 움직임만 보이게).
// 눈금: 원화는 원 단위(100원 반올림), 영어는 달러. 시간축은 폰 시간대.
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/presentation/format.dart';
import '../../market/data/market_models.dart';
import 'ticker_state.dart';

class PriceChart extends StatelessWidget {
  const PriceChart({super.key, required this.chart, required this.kind, required this.usdKrw});

  final ChartData chart;
  final ChartKind kind;

  /// 원화로 그릴 때 환율, 달러면 null
  final double? usdKrw;

  double _value(int cents) => usdKrw == null ? cents / 100 : cents / 100 * usdKrw!;

  String _axis(double v) => usdKrw == null
      ? NumberFormat.currency(locale: 'en_US', symbol: r'$', decimalDigits: v >= 100 ? 0 : 2).format(v)
      : NumberFormat('#,##0', 'ko').format((v / 100).round() * 100);

  String _time(BuildContext context, DateTime t) {
    final locale = Localizations.localeOf(context).toLanguageTag();
    final local = t.toLocal();
    return switch (chart.range) {
      ChartRange.d1 || ChartRange.w1 => DateFormat('M/d HH:mm', locale).format(local),
      _ => DateFormat('yy/M/d', locale).format(local),
    };
  }

  @override
  Widget build(BuildContext context) {
    final bars = chart.bars;
    final colors = upDown(context);
    final trendUp = (chart.rangePct ?? 0) >= 0;
    final trend = trendUp ? colors.up : colors.down;

    final lows = bars.map((b) => _value(kind == ChartKind.line ? b.closeCents : b.lowCents));
    final highs = bars.map((b) => _value(kind == ChartKind.line ? b.closeCents : b.highCents));
    var minY = lows.reduce((a, b) => a < b ? a : b);
    var maxY = highs.reduce((a, b) => a > b ? a : b);
    // 값이 거의 같아도 눈금이 생기게 위아래로 조금 띄운다
    final pad = ((maxY - minY) * 0.1).clamp(maxY * 0.002, double.infinity);
    minY -= pad;
    maxY += pad;

    final titles = FlTitlesData(
      leftTitles: const AxisTitles(),
      topTitles: const AxisTitles(),
      rightTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 72,
          maxIncluded: false,
          minIncluded: false,
          getTitlesWidget: (v, meta) => SideTitleWidget(
            meta: meta,
            child: Text(_axis(v), style: const TextStyle(fontSize: 10, color: neutral)),
          ),
        ),
      ),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          interval: (bars.length / 3).clamp(1, double.infinity).floorToDouble(),
          getTitlesWidget: (v, meta) {
            final i = v.round();
            if (i < 0 || i >= bars.length || v != i) return const SizedBox.shrink();
            return SideTitleWidget(
              meta: meta,
              // 양 끝 글자가 차트 밖으로 잘리지 않게 안쪽으로 민다
              fitInside: SideTitleFitInsideData.fromTitleMeta(meta),
              child: Text(_time(context, bars[i].t), style: const TextStyle(fontSize: 10, color: neutral)),
            );
          },
        ),
      ),
    );
    final grid = FlGridData(
      drawVerticalLine: false,
      getDrawingHorizontalLine: (_) => const FlLine(color: Color(0xFFF3F4F6), strokeWidth: 1),
    );

    if (kind == ChartKind.line) {
      return LineChart(
        LineChartData(
          minX: 0,
          maxX: (bars.length - 1).toDouble().clamp(1, double.infinity),
          minY: minY,
          maxY: maxY,
          titlesData: titles,
          gridData: grid,
          borderData: FlBorderData(show: false),
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (_) => const Color(0xFF111827),
              getTooltipItems: (spots) => [
                for (final s in spots)
                  LineTooltipItem(
                    '${_time(context, bars[s.x.round()].t)}\n${_axis(s.y)}',
                    const TextStyle(color: Colors.white, fontSize: 12),
                  ),
              ],
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: [for (var i = 0; i < bars.length; i++) FlSpot(i.toDouble(), _value(bars[i].closeCents))],
              color: trend,
              barWidth: 2,
              dotData: FlDotData(show: bars.length == 1),
              belowBarData: BarAreaData(show: true, color: trend.withValues(alpha: 0.12)),
            ),
          ],
        ),
      );
    }

    return CandlestickChart(
      CandlestickChartData(
        minX: -0.5,
        maxX: bars.length - 0.5,
        minY: minY,
        maxY: maxY,
        titlesData: titles,
        gridData: grid,
        borderData: FlBorderData(show: false),
        candlestickSpots: [
          for (var i = 0; i < bars.length; i++)
            CandlestickSpot(
              x: i.toDouble(),
              open: _value(bars[i].openCents),
              high: _value(bars[i].highCents),
              low: _value(bars[i].lowCents),
              close: _value(bars[i].closeCents),
            ),
        ],
        candlestickPainter: DefaultCandlestickPainter(
          candlestickStyleProvider: (spot, _) {
            // 시작과 끝이 같으면(가격 변동 없음) 오르지도 내리지도 않은 색
            final c = spot.open == spot.close ? neutral : (spot.isUp ? colors.up : colors.down);
            return CandlestickStyle(
              lineColor: c,
              lineWidth: 1,
              bodyStrokeColor: c,
              // 1시간 봉은 시작=끝(가격 하나)이라 몸통 높이가 0 → 테두리로 가는 선이라도 보이게
              bodyStrokeWidth: 1.5,
              bodyFillColor: c,
              bodyWidth: (240 / bars.length).clamp(2, 10),
              bodyRadius: 1,
            );
          },
        ),
        candlestickTouchData: CandlestickTouchData(
          touchTooltipData: CandlestickTouchTooltipData(
            getTooltipColor: (_) => const Color(0xFF111827),
            getTooltipItems: (_, spot, i) => CandlestickTooltipItem(
              '${_time(context, bars[i].t)}\n${_axis(spot.close)}',
              textStyle: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ),
      ),
    );
  }
}
