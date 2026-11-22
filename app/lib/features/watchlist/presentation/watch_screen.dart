// 관심 탭: 별 표시한 종목 카드(현재가·24H, 걸어 둔 알림), 아래에 내 목표가 알림 전체. 목록이 바뀌면 다시 받는다.
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/presentation/brand.dart';
import '../../../core/presentation/common.dart';
import '../../../core/presentation/format.dart';
import '../../../core/presentation/theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../alerts/data/alert_models.dart';
import '../../alerts/presentation/alerts_cubit.dart';
import '../../market/data/market_models.dart';
import '../../ticker/presentation/ticker_screen.dart' show alertCondition;
import 'watch_prices_cubit.dart';
import 'watch_prices_state.dart';
import 'watchlist_cubit.dart';

class WatchScreen extends StatelessWidget {
  const WatchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return BlocListener<WatchlistCubit, List<String>>(
      listener: (context, keys) => context.read<WatchPricesCubit>().load(keys),
      child: Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 10),
                child: Text(t.watchTitle, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w700)),
              ),
              Expanded(
                child: Builder(
                  builder: (context) {
                    final keys = context.watch<WatchlistCubit>().state;
                    final s = context.watch<WatchPricesCubit>().state;
                    final alerts = context.watch<AlertsCubit>().state.alerts;
                    if (keys.isEmpty && alerts.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: Text(
                            t.watchEmpty,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: AppColors.muted, height: 1.6),
                          ),
                        ),
                      );
                    }
                    if (keys.isNotEmpty && s.details.isEmpty && s.failure != null) {
                      return FailureView(
                        failure: s.failure!,
                        onRetry: () => context.read<WatchPricesCubit>().load(keys),
                      );
                    }
                    if (keys.isNotEmpty && s.details.isEmpty) return const Center(child: CircularProgressIndicator());
                    final fx = s.details.values.isEmpty ? null : s.details.values.first.fx;
                    return RefreshIndicator(
                      color: AppColors.accent,
                      backgroundColor: AppColors.surface,
                      onRefresh: () async {
                        await Future.wait([
                          context.read<WatchPricesCubit>().load(keys),
                          context.read<AlertsCubit>().reload(),
                        ]);
                      },
                      child: ListView(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        children: [
                          for (final k in keys) ...[
                            _card(context, k, s, alerts.where((a) => a.tickerKey == k && a.waiting).toList()),
                            const SizedBox(height: 10),
                          ],
                          if (alerts.isNotEmpty) ...[
                            Padding(
                              padding: const EdgeInsets.fromLTRB(4, 12, 4, 8),
                              child: Text(
                                t.alertsSection,
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.8,
                                  color: AppColors.muted,
                                ),
                              ),
                            ),
                            for (final a in alerts) _alertRow(context, a, fx),
                          ],
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _card(BuildContext context, String key, WatchPricesState s, List<PriceAlert> waiting) {
    final t = AppLocalizations.of(context);
    final d = s.details[key];
    final p = d?.price;
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => context.push('/ticker?key=${Uri.encodeQueryComponent(key)}'),
      child: Panel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(d?.ticker.name ?? key, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                ),
                if (p == null)
                  Tag(t.tooFew)
                else
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        mainPrice(context, p.p25Cents, d!.fx).big,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                      Text(
                        d.change == null ? '— 24H' : '${pct(d.change!.pct)} 24H',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: changeColor(context, d.change?.pct),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            for (final a in waiting) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.notifications_active_outlined, size: 15, color: AppColors.accent),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        alertCondition(context, a, d?.fx),
                        style: const TextStyle(fontSize: 12, color: AppColors.accent, fontWeight: FontWeight.w600),
                      ),
                    ),
                    if (p != null)
                      Text(
                        '${((a.targetCents - p.p25Cents) / p.p25Cents * 100).abs().toStringAsFixed(1)}%',
                        style: const TextStyle(fontSize: 12, color: AppColors.muted),
                      ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _alertRow(BuildContext context, PriceAlert a, Fx? fx) {
    final t = AppLocalizations.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: a.waiting ? AppColors.line : AppColors.lineHi),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.only(left: 14, right: 4),
        leading: Icon(
          a.waiting ? Icons.notifications_active_outlined : Icons.check_rounded,
          color: a.waiting ? AppColors.accent : AppColors.muted,
        ),
        title: Text(a.tickerName, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        subtitle: Text(
          [
            alertCondition(context, a, fx),
            if (!a.waiting && a.firedCents != null) t.alertFired(mainPrice(context, a.firedCents!, fx).big),
          ].join(' · '),
          style: const TextStyle(color: AppColors.sub, fontSize: 12),
        ),
        trailing: IconButton(
          tooltip: t.alertDelete,
          icon: const Icon(Icons.close_rounded, color: AppColors.muted),
          onPressed: () => context.read<AlertsCubit>().delete(a.id),
        ),
        onTap: () => context.push('/ticker?key=${Uri.encodeQueryComponent(a.tickerKey)}'),
      ),
    );
  }
}
