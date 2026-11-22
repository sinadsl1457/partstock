// 아래 탭 막대(시세·관심·설정). 탭을 오가도 각 탭 화면 상태는 남는다(StatefulShellRoute).
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/app_localizations.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.shell});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return Scaffold(
      body: shell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: shell.currentIndex,
        onDestinationSelected: (i) => shell.goBranch(i, initialLocation: i == shell.currentIndex),
        destinations: [
          NavigationDestination(icon: const Icon(Icons.show_chart_rounded), label: t.tabBoard),
          NavigationDestination(
            icon: const Icon(Icons.star_outline_rounded),
            selectedIcon: const Icon(Icons.star_rounded),
            label: t.tabWatch,
          ),
          NavigationDestination(icon: const Icon(Icons.settings_outlined), label: t.tabSettings),
        ],
      ),
    );
  }
}
