// 종목 차트 화면: 현재가·24시간 변동 → 큰 차트(기간·선/봉) → 기간 등락·최고·최저 → 제조사별/모델별. 아래에 eBay·다나와·알림.
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/presentation/brand.dart';
import '../../../core/presentation/common.dart';
import '../../../core/presentation/format.dart';
import '../../../core/presentation/refresh_on_resume.dart';
import '../../../core/presentation/theme.dart';
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
    final t = AppLocalizations.of(context);
    return RefreshOnResume(
      onResume: context.read<TickerCubit>().load,
      child: BlocBuilder<TickerCubit, TickerState>(
        builder: (context, s) {
          final cubit = context.read<TickerCubit>();
          final d = s.detail;
          final category = d == null
              ? null
              : switch (d.ticker.category) {
                  'RAM' => t.categoryRam,
                  'CPU' => t.cpu,
                  'SSD' => t.ssd,
                  _ => t.categoryVga,
                };
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: d == null
                  ? null
                  : Column(
                      children: [
                        Text(d.ticker.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                        Text(
                          category!,
                          style: const TextStyle(fontSize: 10, letterSpacing: 0.8, color: AppColors.muted),
                        ),
                      ],
                    ),
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
      ),
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
      icon: Icon(on ? Icons.star_rounded : Icons.star_outline_rounded, color: on ? AppColors.accent : AppColors.text),
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

    final bars = chart == null || chart.bars.isEmpty ? null : chart.bars;
    final high = bars?.map((b) => b.highCents).reduce((a, b) => a > b ? a : b);
    final low = bars?.map((b) => b.lowCents).reduce((a, b) => a < b ? a : b);
    String money(int cents) => mainPrice(context, cents, d.fx).big;
    final ch = d.change;

    return RefreshIndicator(
      onRefresh: cubit.load,
      color: AppColors.accent,
      backgroundColor: AppColors.surface,
      child: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (crumbs.length > 1)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(crumbs.join('  ›  '), style: const TextStyle(fontSize: 12, color: AppColors.muted)),
                  ),
                if (p == null)
                  Padding(padding: const EdgeInsets.only(top: 6), child: Tag(t.tooFew))
                else ...[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        mainPrice(context, p.priceCents, d.fx).big,
                        style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w700, letterSpacing: -0.6),
                      ),
                      const SizedBox(width: 10),
                      if (mainPrice(context, p.priceCents, d.fx).small case final small?)
                        Text(small, style: const TextStyle(fontSize: 14, color: AppColors.muted)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      _ChangeBadge(pct: ch?.pct, label: '24H'),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          [t.priceHint(p.pricePct, usd(p.medianCents)), t.listingsShort(p.listingCount)].join(' · '),
                          style: const TextStyle(fontSize: 12, color: AppColors.muted),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // 원화 값을 한국 실구매가로 오해하지 않게(미국 eBay 기준, 부가세·배송비·국내 마진 없음)
                  Row(
                    children: [
                      const Icon(Icons.info_outline_rounded, size: 13, color: AppColors.faint),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(t.marketNote, style: const TextStyle(fontSize: 11, color: AppColors.faint)),
                      ),
                    ],
                  ),
                  _WaitingAlerts(tickerKey: d.ticker.key, fx: d.fx),
                ],
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              height: 250,
              padding: const EdgeInsets.fromLTRB(8, 8, 0, 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.line),
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [AppColors.surface, AppColors.bg],
                ),
              ),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: _KindToggle(kind: s.kind, onSelect: cubit.selectKind, line: t.line, candle: t.candle),
                    ),
                  ),
                  Expanded(
                    child: switch (chart) {
                      _ when s.chartPending => const Center(child: CircularProgressIndicator()),
                      null || ChartData(bars: []) => Center(
                        child: Text(t.noChart, style: const TextStyle(color: AppColors.muted)),
                      ),
                      final c => PriceChart(chart: c, kind: s.kind, usdKrw: usdKrw),
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: PillGroup<ChartRange>(
              items: [for (final r in ChartRange.values) (r, rangeLabels[r]!)],
              selected: s.range,
              onSelect: cubit.selectRange,
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: _Stat(
                    label: t.rangeChange(rangeLabels[s.range]!),
                    value: chart?.rangePct == null ? '—' : pct(chart!.rangePct!),
                    color: changeColor(context, chart?.rangePct),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _Stat(label: t.high, value: high == null ? '—' : money(high)),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _Stat(label: t.low, value: low == null ? '—' : money(low)),
                ),
              ],
            ),
          ),
          if (chart != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 10, 20, 0),
              child: Text(
                [
                  bucketLabels[chart.bucket] ?? chart.bucket,
                  if (chart.since != null) t.collecting(timeText(context, chart.since!), chart.points),
                ].join(' · '),
                style: const TextStyle(fontSize: 11, color: AppColors.faint),
              ),
            ),
          if (s.failure != null && s.detail != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
              child: Text(failureText(context, s.failure!), style: const TextStyle(color: AppColors.warn)),
            ),

          if (d.makers.isNotEmpty || d.models.isNotEmpty) ...[
            const SizedBox(height: 22),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: UnderlineTabs<bool>(
                items: [(false, t.makers), (true, t.models)],
                selected: _showModels,
                onSelect: (v) => setState(() => _showModels = v),
              ),
            ),
            if (_showModels)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 2),
                child: Text(t.modelsNote, style: const TextStyle(fontSize: 11, color: AppColors.muted)),
              ),
            for (final c in _showModels ? d.models : d.makers) _ChildRow(child: c, fx: d.fx),
          ],
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
            child: Text(t.source, style: const TextStyle(fontSize: 11, color: AppColors.faint)),
          ),
        ],
      ),
    );
  }
}

/// "▲ 0.40% 24H" 같은 색 띠
class _ChangeBadge extends StatelessWidget {
  const _ChangeBadge({required this.pct, required this.label});
  final double? pct;
  final String label;

  @override
  Widget build(BuildContext context) {
    final c = changeColor(context, pct);
    final arrow = pct == null || pct == 0 ? '' : (pct! > 0 ? '▲ ' : '▼ ');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: c.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(6)),
      child: Text(
        pct == null ? '— $label' : '$arrow${pct!.abs().toStringAsFixed(2)}% $label',
        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: c),
      ),
    );
  }
}

class _KindToggle extends StatelessWidget {
  const _KindToggle({required this.kind, required this.onSelect, required this.line, required this.candle});
  final ChartKind kind;
  final ValueChanged<ChartKind> onSelect;
  final String line;
  final String candle;

  @override
  Widget build(BuildContext context) {
    Widget item(ChartKind k, String label) => Semantics(
      button: true,
      selected: kind == k,
      child: InkWell(
        borderRadius: BorderRadius.circular(6),
        onTap: () => onSelect(k),
        child: Container(
          constraints: const BoxConstraints(minWidth: 44, minHeight: 32),
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: kind == k ? AppColors.lineHi : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: kind == k ? AppColors.accent : AppColors.muted,
            ),
          ),
        ),
      ),
    );
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: AppColors.bg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.line),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [item(ChartKind.line, line), item(ChartKind.candle, candle)],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value, this.color = AppColors.text});
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) => Panel(
    padding: const EdgeInsets.all(10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: AppColors.muted, letterSpacing: 0.4)),
        const SizedBox(height: 2),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            value,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: color),
          ),
        ),
      ],
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
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xFF161A17))),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(child.name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                  if (p != null)
                    Text(t.listingsShort(p.listingCount), style: const TextStyle(fontSize: 11, color: AppColors.muted)),
                ],
              ),
            ),
            if (p == null)
              Tag(t.tooFew)
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    mainPrice(context, p.priceCents, fx).big,
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

/// 아래 고정 버튼: 설정의 기본값(eBay/다나와)이 앞(녹색 버튼), 그 옆 목표가 알림(Android만)
class _JumpBar extends StatelessWidget {
  const _JumpBar({required this.detail});
  final TickerDetail detail;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final links = detail.links;
    final alerts = context.watch<AlertsCubit>().state;
    final jump = context.watch<SettingsCubit>().state.jump;
    final ebay = (label: t.viewOnEbay, url: links.ebay);
    final danawa = (label: t.danawa, url: links.danawa);
    final order = jump == Jump.ebay ? [ebay, danawa] : [danawa, ebay];
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.bar,
        border: Border(top: BorderSide(color: AppColors.line)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
          child: Row(
            children: [
              Expanded(
                child: FilledButton(onPressed: () => openLink(order[0].url), child: Text(order[0].label)),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(onPressed: () => openLink(order[1].url), child: Text(order[1].label)),
              ),
              if (alerts.status != AlertsStatus.unsupported && detail.price != null) ...[
                const SizedBox(width: 8),
                Tooltip(
                  message: t.alertTitle,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(52, 52)),
                    onPressed: () => _openAlert(context),
                    child: const Icon(Icons.notifications_none_rounded, color: AppColors.accent),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> _openAlert(BuildContext context) async {
  final t = AppLocalizations.of(context);
  final cubit = context.read<AlertsCubit>();
  final messenger = ScaffoldMessenger.of(context);
  // 가이드에서 "나중에"를 골랐으면 여기서 권한을 묻고, 등록이 멈춰 있으면 다시 시도
  await cubit.ensureStarted(Localizations.localeOf(context).languageCode);
  if (!context.mounted) return;
  final message = switch (cubit.state.status) {
    AlertsStatus.ready => null,
    AlertsStatus.denied => t.alertDenied,
    _ => t.alertNotReady,
  };
  if (message != null) {
    messenger.showSnackBar(SnackBar(content: Text(message)));
    return;
  }
  final d = context.read<TickerCubit>().state.detail!;
  await showAlertSheet(context, tickerKey: d.ticker.key, nowCents: d.price!.priceCents, fx: d.fx);
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
      padding: const EdgeInsets.only(top: 10),
      child: Wrap(
        spacing: 6,
        runSpacing: 6,
        children: [
          for (final a in waiting)
            Container(
              padding: const EdgeInsets.only(left: 10),
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.notifications_active_outlined, size: 15, color: AppColors.accent),
                  const SizedBox(width: 6),
                  Text(
                    alertCondition(context, a, fx),
                    style: const TextStyle(fontSize: 12, color: AppColors.accent, fontWeight: FontWeight.w600),
                  ),
                  IconButton(
                    tooltip: t.alertDelete,
                    visualDensity: VisualDensity.compact,
                    iconSize: 16,
                    color: AppColors.muted,
                    onPressed: () => context.read<AlertsCubit>().delete(a.id),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
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
