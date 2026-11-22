// 종목 차트 화면: 현재가·24시간 변동 → 큰 차트(기간·선/봉) → 제조사별/모델별. 아래에 eBay·다나와 버튼.
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/presentation/common.dart';
import '../../../core/presentation/format.dart';
import '../../../l10n/app_localizations.dart';
import '../../alerts/data/alert_models.dart';
import '../../alerts/presentation/alert_sheet.dart';
import '../../alerts/presentation/alerts_cubit.dart';
import '../../alerts/presentation/alerts_state.dart';
import '../../market/data/market_models.dart';
import '../../settings/data/settings_repository.dart';
import '../../settings/presentation/settings_cubit.dart';
import '../../watchlist/presentation/watchlist_cubit.dart';
import 'price_chart.dart';
import 'ticker_cubit.dart';
import 'ticker_state.dart';

class TickerScreen extends StatelessWidget {
  const TickerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TickerCubit, TickerState>(
      builder: (context, s) {
        final cubit = context.read<TickerCubit>();
        final d = s.detail;
        return Scaffold(
          appBar: AppBar(
            title: Text(d?.ticker.name ?? '', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
            centerTitle: true,
            actions: [_StarButton(tickerKey: s.key)],
          ),
          body: d == null
              ? (s.failure != null
                    ? FailureView(failure: s.failure!, onRetry: cubit.load)
                    : const Center(child: CircularProgressIndicator()))
              : _Body(state: s, detail: d),
          bottomNavigationBar: d == null ? null : _JumpBar(detail: d),
        );
      },
    );
  }
}

class _StarButton extends StatelessWidget {
  const _StarButton({required this.tickerKey});
  final String tickerKey;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final on = context.select<WatchlistCubit, bool>((c) => c.state.contains(tickerKey));
    return IconButton(
      tooltip: on ? t.removeWatch : t.addWatch,
      onPressed: () => context.read<WatchlistCubit>().toggle(tickerKey),
      icon: Icon(on ? Icons.star_rounded : Icons.star_outline_rounded, color: on ? const Color(0xFFF59E0B) : null),
    );
  }
}

class _Body extends StatefulWidget {
  const _Body({required this.state, required this.detail});
  final TickerState state;
  final TickerDetail detail;

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  bool _showModels = false;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final s = widget.state;
    final d = widget.detail;
    final cubit = context.read<TickerCubit>();
    final p = d.price;
    final chart = s.chart;
    final usdKrw = isKo(context) ? d.fx?.usdKrw : null;
    final crumbs = [d.ticker.chipsetName, ?d.ticker.makerName, ?d.ticker.seriesName];

    final rangeLabels = {
      ChartRange.d1: t.range1d,
      ChartRange.w1: t.range1w,
      ChartRange.m1: t.range1m,
      ChartRange.m3: t.range3m,
      ChartRange.y1: t.range1y,
      ChartRange.all: t.rangeAll,
    };
    final bucketLabels = {'1 hour': t.bucket1h, '4 hours': t.bucket4h, '1 day': t.bucket1d, '7 days': t.bucket7d};

    final values = chart == null || chart.bars.isEmpty ? null : chart.bars;
    final high = values?.map((b) => b.highCents).reduce((a, b) => a > b ? a : b);
    final low = values?.map((b) => b.lowCents).reduce((a, b) => a < b ? a : b);
    String money(int cents) => mainPrice(context, cents, d.fx).big;

    final children = _showModels ? d.models : d.makers;

    return RefreshIndicator(
      onRefresh: cubit.load,
      child: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (crumbs.length > 1) Text(crumbs.join(' › '), style: const TextStyle(fontSize: 13, color: neutral)),
                if (p == null)
                  Padding(padding: const EdgeInsets.only(top: 6), child: Text(t.tooFew))
                else ...[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        mainPrice(context, p.p25Cents, d.fx).big,
                        style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(width: 8),
                      if (mainPrice(context, p.p25Cents, d.fx).small case final small?)
                        Text(small, style: const TextStyle(fontSize: 15, color: Color(0xFF4B5563))),
                    ],
                  ),
                  Text(
                    t.change24h(d.change == null ? '—' : pct(d.change!.pct)),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: changeColor(context, d.change?.pct),
                    ),
                  ),
                  _WaitingAlerts(tickerKey: d.ticker.key, fx: d.fx),
                  Text(
                    [
                      t.priceHint(usd(p.medianCents)),
                      t.listings(p.listingCount),
                      if (d.updatedAt != null) timeText(context, d.updatedAt!),
                    ].join(' · '),
                    style: const TextStyle(fontSize: 12, color: neutral),
                  ),
                ],
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: Wrap(
                    spacing: 12,
                    children: [
                      Text.rich(
                        TextSpan(
                          text: '${t.rangeChange(rangeLabels[s.range]!)} ',
                          children: [
                            TextSpan(
                              text: chart?.rangePct == null ? '—' : pct(chart!.rangePct!),
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: changeColor(context, chart?.rangePct),
                              ),
                            ),
                          ],
                        ),
                        style: const TextStyle(fontSize: 12, color: Color(0xFF4B5563)),
                      ),
                      if (high != null)
                        Text(
                          '${t.high} ${money(high)}',
                          style: const TextStyle(fontSize: 12, color: Color(0xFF4B5563)),
                        ),
                      if (low != null)
                        Text('${t.low} ${money(low)}', style: const TextStyle(fontSize: 12, color: Color(0xFF4B5563))),
                    ],
                  ),
                ),
                SegmentedButton<ChartKind>(
                  segments: [
                    ButtonSegment(value: ChartKind.line, label: Text(t.line)),
                    ButtonSegment(value: ChartKind.candle, label: Text(t.candle)),
                  ],
                  selected: {s.kind},
                  showSelectedIcon: false,
                  style: const ButtonStyle(visualDensity: VisualDensity.compact),
                  onSelectionChanged: (v) => cubit.selectKind(v.first),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 240,
            child: Padding(
              padding: const EdgeInsets.only(left: 12, right: 4),
              child: switch (chart) {
                _ when s.chartPending => const Center(child: CircularProgressIndicator()),
                null || ChartData(bars: []) => Center(
                  child: Text(t.noChart, style: const TextStyle(color: neutral)),
                ),
                final c => PriceChart(chart: c, kind: s.kind, usdKrw: usdKrw),
              },
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SegmentedButton<ChartRange>(
              segments: [for (final r in ChartRange.values) ButtonSegment(value: r, label: Text(rangeLabels[r]!))],
              selected: {s.range},
              showSelectedIcon: false,
              style: const ButtonStyle(
                visualDensity: VisualDensity.compact,
                padding: WidgetStatePropertyAll(EdgeInsets.zero),
              ),
              onSelectionChanged: (v) => cubit.selectRange(v.first),
            ),
          ),
          if (chart != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
              child: Text(
                [
                  bucketLabels[chart.bucket] ?? chart.bucket,
                  if (chart.since != null) t.collecting(timeText(context, chart.since!), chart.points),
                ].join(' · '),
                style: const TextStyle(fontSize: 11, color: neutral),
              ),
            ),
          if (s.failure != null && s.detail != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
              child: Text(failureText(context, s.failure!), style: const TextStyle(color: Color(0xFFB45309))),
            ),

          if (d.makers.isNotEmpty || d.models.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Divider(thickness: 8, height: 8, color: Color(0xFFF3F4F6)),
            Row(
              children: [
                _TabButton(label: t.makers, on: !_showModels, onTap: () => setState(() => _showModels = false)),
                _TabButton(label: t.models, on: _showModels, onTap: () => setState(() => _showModels = true)),
              ],
            ),
            if (_showModels)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
                child: Text(t.modelsNote, style: const TextStyle(fontSize: 12, color: neutral)),
              ),
            for (final c in children) _ChildRow(child: c, fx: d.fx),
          ],
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Text(t.source, style: const TextStyle(fontSize: 11, color: neutral)),
          ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({required this.label, required this.on, required this.onTap});
  final String label;
  final bool on;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Expanded(
    child: InkWell(
      onTap: onTap,
      child: Container(
        height: 48,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: on ? const Color(0xFF111827) : const Color(0xFFE5E7EB), width: 2)),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: on ? FontWeight.w600 : FontWeight.w500,
            color: on ? const Color(0xFF111827) : neutral,
          ),
        ),
      ),
    ),
  );
}

class _ChildRow extends StatelessWidget {
  const _ChildRow({required this.child, required this.fx});
  final Child child;
  final Fx? fx;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final p = child.price;
    return InkWell(
      onTap: () => context.push('/ticker?key=${Uri.encodeQueryComponent(child.key)}'),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(child.name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                  if (p != null) Text(t.listings(p.listingCount), style: const TextStyle(fontSize: 12, color: neutral)),
                ],
              ),
            ),
            if (p == null)
              Text(t.tooFew, style: const TextStyle(fontSize: 12, color: neutral))
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    mainPrice(context, p.p25Cents, fx).big,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                  Text(
                    child.change == null ? '—' : pct(child.change!.pct),
                    style: TextStyle(fontSize: 12, color: changeColor(context, child.change?.pct)),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

/// 아래 고정 버튼: 설정의 기본값(eBay/다나와)이 앞(진한 버튼), 그 옆 목표가 알림(Android만)
class _JumpBar extends StatelessWidget {
  const _JumpBar({required this.detail});
  final TickerDetail detail;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final links = detail.links;
    final alerts = context.watch<AlertsCubit>().state;
    final jump = context.watch<SettingsCubit>().state;
    final ebay = (label: t.viewOnEbay, url: links.ebay);
    final danawa = (label: t.danawa, url: links.danawa);
    final order = jump == Jump.ebay ? [ebay, danawa] : [danawa, ebay];
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
        ),
        child: Row(
          children: [
            Expanded(
              child: FilledButton(
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                  backgroundColor: const Color(0xFF111827),
                ),
                onPressed: () => openLink(order[0].url),
                child: Text(order[0].label),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
                onPressed: () => openLink(order[1].url),
                child: Text(order[1].label),
              ),
            ),
            if (alerts.status != AlertsStatus.unsupported && detail.price != null) ...[
              const SizedBox(width: 8),
              IconButton.outlined(
                tooltip: t.alertTitle,
                constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
                onPressed: () => _openAlert(context, alerts),
                icon: const Icon(Icons.notifications_none_rounded),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

void _openAlert(BuildContext context, AlertsState alerts) {
  final t = AppLocalizations.of(context);
  final d = context.read<TickerCubit>().state.detail!;
  final message = switch (alerts.status) {
    AlertsStatus.ready => null,
    AlertsStatus.denied => t.alertDenied,
    _ => t.alertNotReady,
  };
  // 등록이 실패해 준비 중에 멈춰 있으면 다시 시도
  if (alerts.status == AlertsStatus.starting) context.read<AlertsCubit>().reload();
  if (message != null) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    return;
  }
  showAlertSheet(context, tickerKey: d.ticker.key, nowCents: d.price!.p25Cents, fx: d.fx);
}

/// 이 종목에 걸어 둔 대기 중 알림(현재가 아래 작은 줄)
class _WaitingAlerts extends StatelessWidget {
  const _WaitingAlerts({required this.tickerKey, required this.fx});
  final String tickerKey;
  final Fx? fx;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final waiting = context.select<AlertsCubit, List<PriceAlert>>((c) => c.state.waitingFor(tickerKey));
    if (waiting.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Wrap(
        spacing: 6,
        runSpacing: 6,
        children: [
          for (final a in waiting)
            InputChip(
              avatar: const Icon(Icons.notifications_active_outlined, size: 16),
              label: Text(alertCondition(context, a, fx), style: const TextStyle(fontSize: 12)),
              deleteButtonTooltipMessage: t.alertDelete,
              onDeleted: () => context.read<AlertsCubit>().delete(a.id),
            ),
        ],
      ),
    );
  }
}

/// "180.0만원 이하" / "≤ $1,360"
String alertCondition(BuildContext context, PriceAlert a, Fx? fx) {
  final t = AppLocalizations.of(context);
  final target = mainPrice(context, a.targetCents, fx).big;
  return a.direction == AlertDirection.below ? t.condBelow(target) : t.condAbove(target);
}
