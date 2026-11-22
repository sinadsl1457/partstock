// 처음 실행 가이드(시세 → 차트 → 목표가 알림). 알림을 못 쓰는 기기(iOS)는 앞 두 장만.
// 마지막 장에서 알림 권한을 묻는다(설명을 본 뒤에 묻기). again=true면 설정에서 다시 연 것이라 끝나면 뒤로.
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/presentation/brand.dart';
import '../../../core/presentation/format.dart';
import '../../../core/presentation/theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../alerts/presentation/alerts_cubit.dart';
import '../../alerts/presentation/alerts_state.dart';
import '../../settings/presentation/settings_cubit.dart';

class GuideScreen extends StatefulWidget {
  const GuideScreen({super.key, this.again = false});

  final bool again;

  @override
  State<GuideScreen> createState() => _GuideScreenState();
}

class _GuideScreenState extends State<GuideScreen> {
  final _pages = PageController();
  int _page = 0;

  @override
  void dispose() {
    _pages.dispose();
    super.dispose();
  }

  Future<void> _finish({required bool askPush}) async {
    final alerts = context.read<AlertsCubit>();
    final locale = Localizations.localeOf(context).languageCode;
    await context.read<SettingsCubit>().markGuideSeen();
    // 권한 창이 뜨는 동안 화면은 넘어가도 된다(기다리지 않음)
    if (askPush) alerts.start(locale);
    if (!mounted) return;
    widget.again ? context.pop() : context.go('/board');
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final pushSupported = context.read<AlertsCubit>().state.status != AlertsStatus.unsupported;
    final pages = [
      (t.guide1Title, t.guide1Body, const _BoardPreview()),
      (t.guide2Title, t.guide2Body, const _ChartPreview()),
      if (pushSupported) (t.guide3Title, t.guide3Body, const _AlertPreview()),
    ];
    final last = _page == pages.length - 1;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 44,
                child: Row(
                  children: [
                    if (_page > 0)
                      IconButton(
                        tooltip: t.guidePrev,
                        onPressed: () =>
                            _pages.previousPage(duration: const Duration(milliseconds: 280), curve: Curves.easeOut),
                        icon: const Icon(Icons.chevron_left_rounded, color: AppColors.muted),
                      ),
                    const Spacer(),
                    if (!last)
                      TextButton(
                        onPressed: () => _finish(askPush: false),
                        child: Text(t.guideSkip, style: const TextStyle(color: AppColors.muted)),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: PageView(
                  controller: _pages,
                  onPageChanged: (i) => setState(() => _page = i),
                  children: [
                    for (final (title, body, preview) in pages)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: Center(child: preview)),
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w700,
                              height: 1.3,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(body, style: const TextStyle(fontSize: 15, color: AppColors.sub, height: 1.6)),
                        ],
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var i = 0; i < pages.length; i++)
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: i == _page ? 22 : 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: i == _page ? AppColors.accent : AppColors.lineHi,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: () {
                  if (!last) {
                    _pages.nextPage(duration: const Duration(milliseconds: 280), curve: Curves.easeOut);
                  } else {
                    _finish(askPush: pushSupported);
                  }
                },
                child: Text(!last ? t.guideNext : (pushSupported ? t.guideStartPush : t.guideStart)),
              ),
              if (last && pushSupported)
                TextButton(
                  onPressed: () => _finish(askPush: false),
                  child: Text(t.guideLater, style: const TextStyle(color: AppColors.muted)),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PreviewCard extends StatelessWidget {
  const _PreviewCard({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
    width: 300,
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: AppColors.line),
      boxShadow: [BoxShadow(color: AppColors.accent.withValues(alpha: 0.08), blurRadius: 60)],
    ),
    child: child,
  );
}

class _BoardPreview extends StatelessWidget {
  const _BoardPreview();

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final c = upDown(context);
    final rows = [('RTX 5090', '937.6만원', 1.2), ('RTX 5070 Ti', '187.5만원', 0.4), ('RX 9070 XT', '147.3만원', -2.4)];
    return _PreviewCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          UnderlineTabs<int>(items: [(0, t.gpu), (1, t.ram)], selected: 0, onSelect: (_) {}, fontSize: 13),
          for (final (name, price, ch) in rows)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 4),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Color(0xFF161A17))),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(price, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                      Text(
                        '${ch > 0 ? '▲' : '▼'} ${ch.abs().toStringAsFixed(2)}%',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: ch > 0 ? c.up : c.down),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(t.guide1Badge, style: const TextStyle(fontSize: 12, color: AppColors.accent)),
          ),
        ],
      ),
    );
  }
}

class _ChartPreview extends StatelessWidget {
  const _ChartPreview();

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return _PreviewCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('RTX 5070 Ti  ›  MSI  ›  Gaming Trio', style: TextStyle(fontSize: 12, color: AppColors.muted)),
          const SizedBox(height: 10),
          CustomPaint(size: const Size(268, 110), painter: _AreaPainter()),
          const SizedBox(height: 10),
          IgnorePointer(
            child: PillGroup<int>(
              items: [(0, t.range1d), (1, t.range1w), (2, t.range1m), (3, t.range3m), (4, t.range1y), (5, t.rangeAll)],
              selected: 1,
              onSelect: (_) {},
            ),
          ),
        ],
      ),
    );
  }
}

class _AreaPainter extends CustomPainter {
  static const _ys = [90.0, 84, 94, 62, 70, 48, 58, 30, 40, 18];

  @override
  void paint(Canvas canvas, Size size) {
    final pts = [
      for (var i = 0; i < _ys.length; i++) Offset(i * size.width / (_ys.length - 1), _ys[i] * size.height / 110),
    ];
    final line = Path()..moveTo(pts.first.dx, pts.first.dy);
    for (final p in pts.skip(1)) {
      line.lineTo(p.dx, p.dy);
    }
    final area = Path.from(line)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(
      area,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.accent.withValues(alpha: 0.35), AppColors.accent.withValues(alpha: 0)],
        ).createShader(Offset.zero & size),
    );
    canvas.drawPath(
      line,
      Paint()
        ..color = AppColors.accent
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.4
        ..strokeJoin = StrokeJoin.round,
    );
    canvas.drawCircle(pts.last, 4, Paint()..color = AppColors.accent);
  }

  @override
  bool shouldRepaint(_AreaPainter old) => false;
}

class _AlertPreview extends StatelessWidget {
  const _AlertPreview();

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return Container(
      width: 310,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceHi,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.lineHi),
        boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 40, offset: Offset(0, 12))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.bg,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.lineHi),
            ),
            child: const ChipLogo(size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('partstock', style: TextStyle(fontSize: 11, color: AppColors.muted)),
                const SizedBox(height: 2),
                Text(t.guide3Demo, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                Text(t.guide3DemoBody, style: const TextStyle(fontSize: 13, color: AppColors.sub)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
