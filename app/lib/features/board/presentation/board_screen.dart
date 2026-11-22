// 시세 목록 탭: 그래픽카드/램, 줄마다 미니 추이·대표가·24시간 변동. 누르면 종목 차트로.
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/presentation/common.dart';
import '../../../core/presentation/format.dart';
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
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(t.boardTitle, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w700)),
                      const Spacer(),
                      if (s.board?.updatedAt != null)
                        Text(
                          t.updatedAt(timeText(context, s.board!.updatedAt!)),
                          style: const TextStyle(fontSize: 12, color: neutral),
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SegmentedButton<Category>(
                    segments: [
                      ButtonSegment(value: Category.gpu, label: Text(t.gpu)),
                      ButtonSegment(value: Category.ram, label: Text(t.ram)),
                    ],
                    selected: {s.category},
                    showSelectedIcon: false,
                    onSelectionChanged: (v) => cubit.select(v.first),
                  ),
                ),
                if (s.failure != null && s.board != null)
                  Container(
                    margin: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: const Color(0xFFFEF3C7), borderRadius: BorderRadius.circular(8)),
                    child: Text(
                      '${failureText(context, s.failure!)} · ${t.showingSaved}',
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                const SizedBox(height: 8),
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
      child: ListView.separated(
        itemCount: board.items.length + 1,
        separatorBuilder: (_, _) => const Divider(height: 1, color: Color(0xFFF3F4F6)),
        itemBuilder: (context, i) {
          if (i == board.items.length) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
              child: Text(t.boardNote, style: const TextStyle(fontSize: 12, color: neutral, height: 1.5)),
            );
          }
          return BoardRow(item: board.items[i], fx: board.fx);
        },
      ),
    );
  }
}

class BoardRow extends StatelessWidget {
  const BoardRow({super.key, required this.item, required this.fx});

  final BoardItem item;
  final Fx? fx;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final p = item.price;
    final ch = item.change;
    final vendor = switch (item.vendor) {
      'NVIDIA' => t.vendorNvidia,
      'AMD' => t.vendorAmd,
      'DESKTOP' => t.vendorDesktop,
      _ => item.vendor,
    };
    final spark = item.spark.map((e) => e.p25Cents).toList();
    final trend = spark.length >= 2 ? (spark.last - spark.first).toDouble() : null;
    return InkWell(
      onTap: () => context.push('/ticker?key=${Uri.encodeQueryComponent(item.key)}'),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                  Text(
                    p == null ? vendor : '$vendor · ${t.listingsShort(p.listingCount)}',
                    style: const TextStyle(fontSize: 12, color: neutral),
                  ),
                ],
              ),
            ),
            Sparkline(values: spark, color: changeColor(context, trend)),
            const SizedBox(width: 10),
            SizedBox(
              width: 100,
              child: p == null
                  ? Align(
                      alignment: Alignment.centerRight,
                      child: _TooFew(text: t.tooFew),
                    )
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

class _TooFew extends StatelessWidget {
  const _TooFew({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(color: const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(6)),
    child: Text(text, style: const TextStyle(fontSize: 12, color: neutral)),
  );
}
