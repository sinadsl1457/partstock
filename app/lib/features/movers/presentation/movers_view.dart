// 급등락 탭 내용(시세 탭의 분류 탭 자리에 들어감): 급등 TOP 5, 급락 TOP 5. 줄을 누르면 종목 차트로.
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/presentation/brand.dart';
import '../../../core/presentation/common.dart';
import '../../../core/presentation/format.dart';
import '../../../core/presentation/theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../board/presentation/board_screen.dart' show categoryLabel;
import '../../market/data/market_models.dart';
import 'movers_cubit.dart';
import 'movers_state.dart';

class MoversView extends StatelessWidget {
  const MoversView({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return BlocBuilder<MoversCubit, MoversState>(
      builder: (context, s) {
        final cubit = context.read<MoversCubit>();
        final m = s.movers;
        if (m == null) {
          if (s.failure != null) return FailureView(failure: s.failure!, onRetry: cubit.refresh);
          return const Center(child: CircularProgressIndicator());
        }
        final colors = upDown(context);
        return RefreshIndicator(
          onRefresh: cubit.refresh,
          color: AppColors.accent,
          backgroundColor: AppColors.surface,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(10, 4, 10, 16),
            children: [
              if (s.failure != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(6, 6, 6, 2),
                  child: Text(
                    '${failureText(context, s.failure!)} · ${t.showingSaved}',
                    style: const TextStyle(fontSize: 13, color: AppColors.warn),
                  ),
                ),
              _Header(title: t.moversUp, color: colors.up),
              ..._rows(m.up, m.fx, t.moversNoneUp),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: Divider(height: 1, color: AppColors.line),
              ),
              _Header(title: t.moversDown, color: colors.down),
              ..._rows(m.down, m.fx, t.moversNoneDown),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 14, 12, 0),
                child: Text(
                  t.moversNote(m.minListings),
                  style: const TextStyle(fontSize: 11, color: AppColors.muted, height: 1.6),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static List<Widget> _rows(List<Mover> list, Fx? fx, String empty) => list.isEmpty
      ? [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 6, 12, 10),
            child: Text(empty, style: const TextStyle(fontSize: 13, color: AppColors.muted)),
          ),
        ]
      : [for (final (i, m) in list.indexed) _MoverRow(rank: i + 1, mover: m, fx: fx)];
}

class _Header extends StatelessWidget {
  const _Header({required this.title, required this.color});
  final String title;
  final Color color;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: color),
        ),
        Text(AppLocalizations.of(context).moversVs, style: const TextStyle(fontSize: 11, color: AppColors.muted)),
      ],
    ),
  );
}

class _MoverRow extends StatelessWidget {
  const _MoverRow({required this.rank, required this.mover, required this.fx});
  final int rank;
  final Mover mover;
  final Fx? fx;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final p = mover.price;
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => context.push('/ticker?key=${Uri.encodeQueryComponent(mover.key)}'),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Row(
          children: [
            SizedBox(
              width: 22,
              child: Text(
                '$rank',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.muted),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mover.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${categoryLabel(t, mover.category)} · ${t.listingsShort(p.listingCount)}',
                    style: const TextStyle(fontSize: 11, color: AppColors.muted),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  mainPrice(context, p.priceCents, fx).big,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 3),
                ChangePill(pct: mover.change.pct),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
