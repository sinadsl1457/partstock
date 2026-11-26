// 시세 목록 탭: 로고·업데이트 시각, VGA/RAM, 줄마다 판매처·미니 추이·대표가·24시간 변동. 누르면 종목 차트로.
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/network/app_failure.dart';
import '../../../core/presentation/brand.dart';
import '../../../core/presentation/common.dart';
import '../../../core/presentation/format.dart';
import '../../../core/presentation/refresh_on_resume.dart';
import '../../../core/presentation/theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../market/data/market_models.dart';
import '../../movers/presentation/movers_cubit.dart';
import '../../movers/presentation/movers_view.dart';
import '../data/board_filter.dart';
import 'board_cubit.dart';
import 'filter_sheet.dart';
import 'board_state.dart';

/// 분류 탭 줄에서 급등락 탭을 가리키는 값
const _moversTab = 'movers';

class BoardScreen extends StatelessWidget {
  const BoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return RefreshOnResume(
      onResume: () {
        // 네 분류는 늘 같이 새로 받고, 급등락은 받아 둔 적이 있으면 같이
        context.read<BoardCubit>().refresh();
        if (context.read<MoversCubit>().state.movers != null) context.read<MoversCubit>().refresh();
      },
      child: Scaffold(
        body: SafeArea(
          child: BlocBuilder<BoardCubit, BoardState>(
            builder: (context, s) {
              final updated = s.updatedAt;
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
                    child: Stack(
                      children: [
                        UnderlineTabs<Object>(
                          items: [for (final c in Category.values) (c, categoryLabel(t, c)), (_moversTab, t.tabMovers)],
                          selected: s.movers ? _moversTab : s.category,
                          onSelect: (v) => _open(context, v),
                        ),
                        if (!s.movers) Positioned(right: 0, top: 0, bottom: 2, child: _FilterButton(state: s)),
                      ],
                    ),
                  ),
                  if (!s.movers)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(22, 12, 22, 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            t.colName,
                            style: const TextStyle(fontSize: 11, color: AppColors.muted, letterSpacing: 0.4),
                          ),
                          Text(
                            t.colPrice,
                            style: const TextStyle(fontSize: 11, color: AppColors.muted, letterSpacing: 0.4),
                          ),
                        ],
                      ),
                    ),
                  if (!s.movers && s.failure != null && s.board != null)
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
                  // 목록을 좌우로 밀면 손가락을 따라 옆 분류 탭이 들어온다(왼쪽으로 밀면 다음).
                  Expanded(
                    child: _TabPager(
                      index: _tabs.indexOf(s.movers ? _moversTab : s.category),
                      count: _tabs.length,
                      onPage: (i) => _open(context, _tabs[i]),
                      page: (context, i) => _page(context, s, _tabs[i]),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  static const _tabs = <Object>[...Category.values, _moversTab];

  void _open(BuildContext context, Object tab) {
    if (tab is Category) {
      context.read<BoardCubit>().select(tab);
    } else {
      context.read<BoardCubit>().showMovers();
      context.read<MoversCubit>().open();
    }
  }

  /// 지금 탭은 상태 그대로, 밀어서 들어오는 옆 탭은 저장해 둔 목록(없으면 로딩)
  Widget _page(BuildContext context, BoardState s, Object tab) {
    if (tab is! Category) return const MoversView();
    final cubit = context.read<BoardCubit>();
    if (!s.movers && tab == s.category) return _body(context, s.board, s.filter, s.failure, cubit);
    final peek = cubit.peek(tab);
    return _body(context, peek.board, peek.filter, null, cubit);
  }

  Widget _body(BuildContext context, Board? board, BoardFilter filter, AppFailure? failure, BoardCubit cubit) {
    if (board == null) {
      if (failure != null) return FailureView(failure: failure, onRetry: cubit.refresh);
      return const Center(child: CircularProgressIndicator());
    }
    final t = AppLocalizations.of(context);
    final items = board.items.where((i) => matchesFilter(i, filter)).toList();
    return RefreshIndicator(
      onRefresh: cubit.refresh,
      color: AppColors.accent,
      backgroundColor: AppColors.surface,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(10, 4, 10, 12),
        itemCount: items.length + 1,
        itemBuilder: (context, i) {
          if (i == items.length) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(12, 14, 12, 12),
              child: Text(t.boardNote, style: const TextStyle(fontSize: 11, color: AppColors.muted, height: 1.6)),
            );
          }
          return BoardRow(item: items[i], fx: board.fx);
        },
      ),
    );
  }
}

/// 분류 탭을 좌우로 넘기는 화면. 밀어서 넘기면 onPage, 위 탭을 눌러 index가 바뀌면 그 쪽으로 미끄러져 간다.
class _TabPager extends StatefulWidget {
  const _TabPager({required this.index, required this.count, required this.onPage, required this.page});

  final int index;
  final int count;
  final ValueChanged<int> onPage;
  final Widget Function(BuildContext context, int index) page;

  @override
  State<_TabPager> createState() => _TabPagerState();
}

class _TabPagerState extends State<_TabPager> {
  late final PageController _controller = PageController(initialPage: widget.index);

  /// 탭을 눌러 미끄러져 가는 동안 지나가는 탭(VGA → SSD면 RAM·CPU)은 열지 않는다
  bool _sliding = false;

  @override
  void didUpdateWidget(_TabPager old) {
    super.didUpdateWidget(old);
    final now = _controller.hasClients ? _controller.page?.round() : null;
    if (now == null || now == widget.index) return;
    _sliding = true;
    _controller
        .animateToPage(widget.index, duration: const Duration(milliseconds: 280), curve: Curves.easeOutCubic)
        .whenComplete(() => _sliding = false);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => PageView.builder(
    controller: _controller,
    itemCount: widget.count,
    onPageChanged: (i) {
      if (!_sliding && i != widget.index) widget.onPage(i);
    },
    itemBuilder: widget.page,
  );
}

/// 탭 오른쪽 "필터" 버튼. 처음 값과 다르게 고른 묶음 수를 녹색 숫자로
class _FilterButton extends StatelessWidget {
  const _FilterButton({required this.state});

  final BoardState state;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final changed = changedCount(state.category, state.filter);
    final label = categoryLabel(t, state.category);
    return TextButton.icon(
      style: TextButton.styleFrom(
        foregroundColor: changed > 0 ? AppColors.accent : AppColors.sub,
        padding: const EdgeInsets.symmetric(horizontal: 8),
      ),
      onPressed: state.board == null
          ? null
          : () async {
              final cubit = context.read<BoardCubit>();
              final picked = await showFilterSheet(
                context,
                category: state.category,
                categoryLabel: label,
                current: state.filter,
                items: state.board!.items,
              );
              if (picked != null) await cubit.setFilter(picked);
            },
      icon: const Icon(Icons.tune_rounded, size: 18),
      label: Text(
        changed > 0 ? '${t.filter} $changed' : t.filter,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      ),
    );
  }
}

/// 탭 이름: 한국어 VGA·RAM·CPU, 영어 GPU·RAM·CPU
String categoryLabel(AppLocalizations t, Category c) => switch (c) {
  Category.gpu => t.gpu,
  Category.ram => t.ram,
  Category.cpu => t.cpu,
  Category.ssd => t.ssd,
};

String vendorLabel(AppLocalizations t, String vendor) => switch (vendor) {
  'NVIDIA' => t.vendorNvidia,
  'AMD' => t.vendorAmd,
  'INTEL' => t.vendorIntel,
  'NVME5' => 'NVMe Gen5',
  'NVME4' => 'NVMe Gen4',
  'SATA' => 'SATA',
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
    final spark = item.spark.map((e) => e.priceCents).toList();
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
                        Flexible(
                          child: Text.rich(
                            listingsSpan(t, p.listingCount, p.fewListings),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
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
                          mainPrice(context, p.priceCents, fx).big,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 3),
                        // 이 앱은 값보다 흐름이 핵심이라 등락을 색 띠로 눈에 띄게(11/23 사용자 결정)
                        ChangePill(pct: ch?.pct),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
