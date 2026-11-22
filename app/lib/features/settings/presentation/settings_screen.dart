// 설정 탭: 바로가기 기본값, 알림 상태·걸어 둔 목표가, 가격 기준, 가이드 다시 보기·앱 버전.
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../core/presentation/brand.dart';
import '../../../core/presentation/theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../alerts/presentation/alerts_cubit.dart';
import '../../alerts/presentation/alerts_state.dart';
import '../data/settings_repository.dart';
import 'settings_cubit.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final jump = context.watch<SettingsCubit>().state.jump;
    final alerts = context.watch<AlertsCubit>().state;
    final waiting = alerts.alerts.where((a) => a.waiting).length;
    final (pushText, pushOn) = switch (alerts.status) {
      AlertsStatus.ready => (t.pushOn, true),
      AlertsStatus.unsupported => (t.pushUnsupported, false),
      _ => (t.pushOff, false),
    };
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 14, 4, 14),
              child: Text(t.settingsTitle, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w700)),
            ),
            _Section(title: t.sectionJump),
            Panel(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(color: AppColors.bg, borderRadius: BorderRadius.circular(12)),
                    child: PillGroup<Jump>(
                      items: [(Jump.ebay, 'eBay'), (Jump.danawa, t.danawa)],
                      selected: jump,
                      onSelect: context.read<SettingsCubit>().setJump,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(t.jumpDefaultHint, style: const TextStyle(fontSize: 12, color: AppColors.muted)),
                ],
              ),
            ),
            _Section(title: t.sectionAlerts),
            Panel(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _Row(
                    title: t.pushStatus,
                    subtitle: alerts.status == AlertsStatus.unsupported ? null : t.pushHint,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (pushOn) ...[const GlowDot(), const SizedBox(width: 6)],
                        Text(
                          pushText,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: pushOn ? AppColors.accent : AppColors.muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (alerts.status != AlertsStatus.unsupported) ...[
                    const Divider(height: 1),
                    _Row(
                      title: t.alertsCount,
                      trailing: Text(
                        t.alertsCountValue('$waiting'),
                        style: const TextStyle(fontSize: 14, color: AppColors.sub),
                      ),
                      onTap: () => context.go('/watch'),
                    ),
                  ],
                ],
              ),
            ),
            _Section(title: t.sectionBasis),
            Panel(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Basis(label: t.basisPriceLabel, text: t.basisPrice),
                  const SizedBox(height: 10),
                  _Basis(label: t.basisFxLabel, text: t.basisFx),
                  const SizedBox(height: 10),
                  _Basis(label: t.basisUpdateLabel, text: t.basisUpdate),
                ],
              ),
            ),
            _Section(title: t.sectionHelp),
            Panel(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _Row(title: t.guideAgain, onTap: () => context.push('/guide?again=1')),
                  const Divider(height: 1),
                  _Row(
                    title: t.appVersion,
                    trailing: FutureBuilder<PackageInfo>(
                      future: PackageInfo.fromPlatform(),
                      builder: (_, snap) =>
                          Text(snap.data?.version ?? '', style: const TextStyle(fontSize: 14, color: AppColors.muted)),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 12, 4, 0),
              child: Text(t.source, style: const TextStyle(fontSize: 11, color: AppColors.faint, height: 1.6)),
            ),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(4, 18, 4, 8),
    child: Text(
      title,
      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.8, color: AppColors.muted),
    ),
  );
}

class _Row extends StatelessWidget {
  const _Row({required this.title, this.subtitle, this.trailing, this.onTap});
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    child: Container(
      constraints: const BoxConstraints(minHeight: 52),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                if (subtitle != null) Text(subtitle!, style: const TextStyle(fontSize: 12, color: AppColors.muted)),
              ],
            ),
          ),
          ?trailing,
          if (onTap != null) ...[
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right_rounded, color: AppColors.muted),
          ],
        ],
      ),
    ),
  );
}

class _Basis extends StatelessWidget {
  const _Basis({required this.label, required this.text});
  final String label;
  final String text;

  @override
  Widget build(BuildContext context) => Text.rich(
    TextSpan(
      children: [
        TextSpan(
          text: '$label  ',
          style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.text),
        ),
        TextSpan(text: text),
      ],
    ),
    style: const TextStyle(fontSize: 13, color: AppColors.sub, height: 1.5),
  );
}
