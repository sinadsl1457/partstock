// 설정 탭: 바로가기 기본값(eBay/다나와)과 데이터 출처.
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/presentation/format.dart';
import '../../../l10n/app_localizations.dart';
import '../data/settings_repository.dart';
import 'settings_cubit.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final jump = context.watch<SettingsCubit>().state;
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
              child: Text(t.settingsTitle, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w700)),
            ),
            ListTile(
              title: Text(t.jumpDefault, style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text(t.jumpDefaultHint),
            ),
            RadioGroup<Jump>(
              groupValue: jump,
              onChanged: (j) => context.read<SettingsCubit>().setJump(j!),
              child: Column(
                children: [
                  RadioListTile<Jump>(value: Jump.ebay, title: const Text('eBay')),
                  RadioListTile<Jump>(value: Jump.danawa, title: Text(t.danawa)),
                ],
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                '${t.boardNote}\n\n${t.source}',
                style: const TextStyle(fontSize: 12, color: neutral, height: 1.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
