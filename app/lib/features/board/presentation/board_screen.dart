// 시세 목록 탭: 로고·업데이트 시각, VGA/RAM, 줄마다 판매처·미니 추이·대표가·24시간 변동. 누르면 종목 차트로.
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/presentation/brand.dart';
import '../../../core/presentation/common.dart';
import '../../../core/presentation/format.dart';
import '../../../core/presentation/theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../market/data/market_models.dart';
import 'board_cubit.dart';
import 'board_state.dart';

class BoardScreen extends StatelessWidget {
  const BoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<BoardCubit, BoardState>(
          builder: (context, s) {
            final cubit = context.read<BoardCubit>();
            final updated = s.board?.updatedAt;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
                  child: Row(
                    children: [
                      const ChipLogo(size: 28),
                      const SizedBox(width: 10),
                      const Wordmark(),
                      const SizedBox(width: 12),
                      // 좁은 폰에서는 업데이트 표시가 줄어들며 말줄임(로고는 그대로)
                      if (updated != null)
                        Flexible(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.lineHi),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const GlowDot(),
                                  const SizedBox(width: 6),
                                  Flexible(
                                    child: Text(
                                      t.updatedPill(DateFormat.Hm().format(updated.toLocal())),
                                      style: const TextStyle(fontSize: 12, color: AppColors.sub),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: UnderlineTabs<Category>(
                    items: [(Category.gpu, t.gpu), (Category.ram, t.ram)],
                    selected: s.category,
                    onSelect: cubit.select,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(22, 12, 22, 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(t.colName, style: const TextStyle(fontSize: 11, color: AppColors.muted, letterSpacing: 0.4)),
                      Text(
                        t.colPrice,
                        style: const TextStyle(fontSize: 11, color: AppColors.muted, letterSpacing: 0.4),
                      ),
                    ],
                  ),
                ),
                if (s.failure != null && s.board != null)
                  Container(
                    margin: const EdgeInsets.fromLTRB(16, 6, 16, 2),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.warn.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${failureText(context, s.failure!)} · ${t.showingSaved}',
                      style: const TextStyle(fontSize: 13, color: AppColors.warn),
                    ),
                  ),
                Expanded(child: _body(context, s, cubit)),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _body(BuildContext context, BoardState s, BoardCubit cubit) {
    final board = s.board;
    if (board == null) {
      if (s.failure != null) return FailureView(failure: s.failure!, onRetry: cubit.refresh);
      return const Center(child: CircularProgressIndicator());
    }
    final t = AppLocalizations.of(context);
    return RefreshIndicator(
      onRefresh: cubit.refresh,
      color: AppColors.accent,
      backgroundColor: AppColors.surface,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(10, 4, 10, 12),
        itemCount: board.items.length + 1,
        itemBuilder: (context, i) {
          if (i == board.items.length) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(12, 14, 12, 12),
              child: Text(t.boardNote, style: const TextStyle(fontSize: 11, color: AppColors.muted, height: 1.6)),
            );
          }
          return BoardRow(item: board.items[i], fx: board.fx);
        },
      ),
    );
  }
}

String vendorLabel(AppLocalizations t, String vendor) => switch (vendor) {
  'NVIDIA' => t.vendorNvidia,
  'AMD' => t.vendorAmd,
  'DESKTOP' => t.vendorDesktop,
  _ => vendor,
};

class BoardRow extends StatelessWidget {
  const BoardRow({super.key, required this.item, required this.fx});

  final BoardItem item;
  final Fx? fx;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final p = item.price;
    final ch = item.change;
    final spark = item.spark.map((e) => e.p25Cents).toList();
    final trend = spark.length >= 2 ? (spark.last - spark.first).toDouble() : null;
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => context.push('/ticker?key=${Uri.encodeQueryComponent(item.key)}'),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Tag(vendorLabel(t, item.vendor)),
                      if (p != null) ...[
                        const SizedBox(width: 6),
                        Text(
                          t.listingsShort(p.listingCount),
                          style: const TextStyle(fontSize: 11, color: AppColors.muted),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            Sparkline(values: spark, color: changeColor(context, trend), size: const Size(58, 26)),
            const SizedBox(width: 10),
            SizedBox(
              width: 96,
              child: p == null
                  ? Align(alignment: Alignment.centerRight, child: Tag(t.tooFew))
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          mainPrice(context, p.p25Cents, fx).big,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                        Text(
                          ch == null ? '—' : pct(ch.pct),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: changeColor(context, ch?.pct),
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
