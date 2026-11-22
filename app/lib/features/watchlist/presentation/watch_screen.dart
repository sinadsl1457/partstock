// 관심 탭: 별 표시한 종목의 현재가. 목록이 바뀌면(차트 화면에서 별을 누르면) 다시 받는다.
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/presentation/common.dart';
import '../../../core/presentation/format.dart';
import '../../../l10n/app_localizations.dart';
import '../../alerts/presentation/alerts_cubit.dart';
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
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
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
                        child: Text(
                          t.watchEmpty,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: neutral),
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
                    return RefreshIndicator(
                      onRefresh: () async {
                        await Future.wait([
                          context.read<WatchPricesCubit>().load(keys),
                          context.read<AlertsCubit>().reload(),
                        ]);
                      },
                      child: ListView(
                        children: [
                          for (final k in keys) _row(context, k, s),
                          if (alerts.isNotEmpty) ...[
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                              child: Text(
                                t.alertsSection,
                                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: neutral),
                              ),
                            ),
                            for (final a in alerts)
                              ListTile(
                                contentPadding: const EdgeInsets.only(left: 20, right: 8),
                                leading: Icon(
                                  a.waiting ? Icons.notifications_active_outlined : Icons.notifications_off_outlined,
                                  color: a.waiting ? const Color(0xFF1D4ED8) : neutral,
                                ),
                                title: Text(a.tickerName, style: const TextStyle(fontWeight: FontWeight.w600)),
                                subtitle: Text(
                                  [
                                    alertCondition(context, a, s.details[a.tickerKey]?.fx),
                                    if (!a.waiting && a.firedCents != null)
                                      t.alertFired(mainPrice(context, a.firedCents!, s.details[a.tickerKey]?.fx).big),
                                  ].join(' · '),
                                ),
                                trailing: IconButton(
                                  tooltip: t.alertDelete,
                                  icon: const Icon(Icons.close_rounded),
                                  onPressed: () => context.read<AlertsCubit>().delete(a.id),
                                ),
                                onTap: () => context.push('/ticker?key=${Uri.encodeQueryComponent(a.tickerKey)}'),
                              ),
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

  Widget _row(BuildContext context, String key, WatchPricesState s) {
    final t = AppLocalizations.of(context);
    final d = s.details[key];
    final p = d?.price;
    return InkWell(
      onTap: () => context.push('/ticker?key=${Uri.encodeQueryComponent(key)}'),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xFFF3F4F6))),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(d?.ticker.name ?? key, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
            ),
            if (p == null)
              Text(t.tooFew, style: const TextStyle(fontSize: 12, color: neutral))
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    mainPrice(context, p.p25Cents, d!.fx).big,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  Text(
                    t.change24h(d.change == null ? '—' : pct(d.change!.pct)),
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
      ),
    );
  }
}
