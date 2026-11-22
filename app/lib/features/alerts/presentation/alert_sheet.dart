// 목표가 알림 창(종목 차트의 종 버튼): 이하/이상, 빠른 % 버튼, 목표 가격. 한국어는 만원, 영어는 달러로 넣는다.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/app_failure.dart';
import '../../../core/presentation/common.dart';
import '../../../core/presentation/format.dart';
import '../../../l10n/app_localizations.dart';
import '../../market/data/market_models.dart';
import '../data/alert_models.dart';
import 'alerts_cubit.dart';

/// 화면 단위(만원 또는 달러) ↔ 센트. 서버는 USD 센트만 안다.
class AlertUnits {
  const AlertUnits(this.usdKrw);

  /// 원화로 넣을 때 환율, 달러면 null
  final double? usdKrw;

  double fromCents(int cents) => usdKrw == null ? cents / 100 : cents / 100 * usdKrw! / 10000;

  int toCents(double v) => usdKrw == null ? (v * 100).round() : (v * 10000 / usdKrw! * 100).round();

  String text(double v) => usdKrw == null ? v.round().toString() : v.toStringAsFixed(1);
}

Future<void> showAlertSheet(BuildContext context, {required String tickerKey, required int nowCents, Fx? fx}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => BlocProvider.value(
      value: context.read<AlertsCubit>(),
      child: AlertSheet(tickerKey: tickerKey, nowCents: nowCents, units: AlertUnits(isKo(context) ? fx?.usdKrw : null)),
    ),
  );
}

class AlertSheet extends StatefulWidget {
  const AlertSheet({super.key, required this.tickerKey, required this.nowCents, required this.units});

  final String tickerKey;
  final int nowCents;
  final AlertUnits units;

  @override
  State<AlertSheet> createState() => _AlertSheetState();
}

class _AlertSheetState extends State<AlertSheet> {
  AlertDirection _dir = AlertDirection.below;
  int _pct = 5;
  late final TextEditingController _input = TextEditingController(text: _textFor(5));
  bool _saving = false;

  double get _now => widget.units.fromCents(widget.nowCents);

  String _textFor(int pct) {
    final sign = _dir == AlertDirection.below ? -1 : 1;
    return widget.units.text(_now * (1 + sign * pct / 100));
  }

  void _pick(int pct) => setState(() {
    _pct = pct;
    _input.text = _textFor(pct);
  });

  @override
  void dispose() {
    _input.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final t = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final v = double.tryParse(_input.text.replaceAll(',', ''));
    if (v == null || v <= 0) {
      messenger.showSnackBar(SnackBar(content: Text(t.alertInvalid)));
      return;
    }
    setState(() => _saving = true);
    final f = await context.read<AlertsCubit>().create(widget.tickerKey, _dir, widget.units.toCents(v));
    if (!mounted) return;
    setState(() => _saving = false);
    if (f == null) {
      Navigator.of(context).pop();
      messenger.showSnackBar(SnackBar(content: Text(t.alertSaved)));
    } else {
      messenger.showSnackBar(
        SnackBar(content: Text(f is ServerFailure && f.status == 409 ? t.alertLimit : failureText(context, f))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final v = double.tryParse(_input.text.replaceAll(',', ''));
    final diff = v == null || _now == 0 ? null : ((v - _now).abs() / _now * 100);
    final below = _dir == AlertDirection.below;
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 20 + MediaQuery.viewInsetsOf(context).bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(t.alertTitle, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(t.alertNow(_nowText()), style: const TextStyle(color: Color(0xFF4B5563))),
          const SizedBox(height: 16),
          SegmentedButton<AlertDirection>(
            segments: [
              ButtonSegment(value: AlertDirection.below, label: Text(t.alertBelow)),
              ButtonSegment(value: AlertDirection.above, label: Text(t.alertAbove)),
            ],
            selected: {_dir},
            showSelectedIcon: false,
            onSelectionChanged: (s) => setState(() {
              _dir = s.first;
              _input.text = _textFor(_pct);
            }),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _input,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))],
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
            decoration: InputDecoration(
              labelText: widget.units.usdKrw == null ? t.alertTargetUsd : t.alertTargetKo,
              suffixText: widget.units.usdKrw == null ? r'$' : '만원',
              border: const OutlineInputBorder(),
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 6),
          if (diff != null)
            Text(
              below ? t.alertLower(diff.toStringAsFixed(1)) : t.alertHigher(diff.toStringAsFixed(1)),
              style: TextStyle(fontSize: 13, color: below ? upDown(context).down : upDown(context).up),
            ),
          const SizedBox(height: 12),
          Row(
            children: [
              for (final p in const [3, 5, 10, 15]) ...[
                Expanded(
                  child: ChoiceChip(
                    label: Text('${below ? '−' : '+'}$p%'),
                    selected: _pct == p,
                    onSelected: (_) => _pick(p),
                  ),
                ),
                if (p != 15) const SizedBox(width: 6),
              ],
            ],
          ),
          const SizedBox(height: 12),
          Text(t.alertNote, style: const TextStyle(fontSize: 12, color: neutral, height: 1.5)),
          const SizedBox(height: 16),
          FilledButton(
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
              backgroundColor: const Color(0xFF111827),
            ),
            onPressed: _saving ? null : _save,
            child: Text(t.alertSave),
          ),
        ],
      ),
    );
  }

  String _nowText() {
    final u = widget.units;
    return u.usdKrw == null ? usd(widget.nowCents) : '${u.text(_now)}만원';
  }
}
