// 시세 목록 필터 창(아래에서 올라오는 창). 분류마다 filterGroups에 정한 묶음을 버튼으로 보여 주고,
// 고르는 동안 맞는 종목 수를 바로 세어 "N개 종목 보기"에 표시한다. 적용을 눌러야 목록이 바뀐다.
import 'package:flutter/material.dart';

import '../../../core/presentation/theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../market/data/market_models.dart';
import '../data/board_filter.dart';

/// 고른 필터를 돌려준다(닫기만 하면 null)
Future<BoardFilter?> showFilterSheet(
  BuildContext context, {
  required Category category,
  required String categoryLabel,
  required BoardFilter current,
  required List<BoardItem> items,
}) => showModalBottomSheet<BoardFilter>(
  context: context,
  isScrollControlled: true,
  showDragHandle: true,
  builder: (_) => _FilterSheet(category: category, categoryLabel: categoryLabel, current: current, items: items),
);

/// 필터 값의 화면 글자: RTX50 → RTX 50, DDR5 그대로, pack 1 → 1개
String facetValueLabel(AppLocalizations t, String facet, String value) => switch (facet) {
  'series' => value.replaceFirstMapped(RegExp(r'^(RTX|RX)(\d+)$'), (m) => '${m[1]} ${m[2]}'),
  'pack' => value == '1' ? t.pack_1 : t.pack_2,
  _ => value,
};

String facetLabel(AppLocalizations t, String facet) => switch (facet) {
  'series' => t.filter_series,
  'ddr' => t.filter_ddr,
  'pack' => t.filter_pack,
  _ => facet,
};

class _FilterSheet extends StatefulWidget {
  const _FilterSheet({required this.category, required this.categoryLabel, required this.current, required this.items});

  final Category category;
  final String categoryLabel;
  final BoardFilter current;
  final List<BoardItem> items;

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  late BoardFilter _f = {
    for (final e in widget.current.entries) e.key: {...e.value},
  };

  void _tap(FilterGroup g, String v) => setState(() {
    final now = {...?_f[g.facet]};
    if (g.single) {
      _f[g.facet] = {v};
    } else {
      now.contains(v) ? now.remove(v) : now.add(v);
      _f[g.facet] = now;
    }
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final count = widget.items.where((i) => matchesFilter(i, _f)).length;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    t.filterTitle(widget.categoryLabel),
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                ),
                TextButton(
                  onPressed: () => setState(() => _f = initialFilter(widget.category)),
                  child: Text(t.filterReset, style: const TextStyle(color: AppColors.muted)),
                ),
              ],
            ),
            for (final g in filterGroups[widget.category]!) ...[
              const SizedBox(height: 14),
              Text(
                facetLabel(t, g.facet),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.6,
                  color: AppColors.muted,
                ),
              ),
              if (!g.single)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(t.filterHintMulti, style: const TextStyle(fontSize: 11, color: AppColors.faint)),
                ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final v in g.values)
                    _Chip(
                      label: facetValueLabel(t, g.facet, v),
                      on: _f[g.facet]?.contains(v) ?? false,
                      onTap: () => _tap(g, v),
                    ),
                ],
              ),
            ],
            const SizedBox(height: 22),
            FilledButton(
              onPressed: count == 0 ? null : () => Navigator.pop(context, _f),
              child: Text(count == 0 ? t.filterEmpty : t.filterApply(count)),
            ),
          ],
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label, required this.on, required this.onTap});

  final String label;
  final bool on;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    selected: on,
    child: InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        // alignment를 주면 상자가 줄 전체로 늘어나서, 글자 + 여백만큼만
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
        decoration: BoxDecoration(
          color: on ? AppColors.accent.withValues(alpha: 0.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: on ? AppColors.accent : AppColors.lineHi),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (on) ...[const Icon(Icons.check_rounded, size: 16, color: AppColors.accent), const SizedBox(width: 4)],
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: on ? FontWeight.w700 : FontWeight.w500,
                color: on ? AppColors.accent : AppColors.sub,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
