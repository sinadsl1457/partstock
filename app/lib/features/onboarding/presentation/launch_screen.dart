// 런치 애니메이션(약 1.4초, 누르면 바로 넘어감): 칩 테두리·핀 → 가운데 칩이 톡 튀며 빛남 → 글자 → 시세 선.
// 끝나면 가이드를 본 적 없으면 가이드, 있으면 시세 목록으로.
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/presentation/brand.dart';
import '../../../core/presentation/theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../settings/presentation/settings_cubit.dart';

class LaunchScreen extends StatefulWidget {
  const LaunchScreen({super.key});

  @override
  State<LaunchScreen> createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 1400));
  bool _left = false;

  // 시간표(전체 1.4초 중 구간)
  late final _frame = _part(0.0, 0.30, Curves.easeOut);
  late final _pins = _part(0.05, 0.35, Curves.easeOut);
  late final _core = _part(0.25, 0.50, Curves.easeOut);
  late final _glow = _part(0.30, 0.60, Curves.easeOut);
  late final _word = _part(0.45, 0.70, Curves.easeOutCubic);
  late final _tick = _part(0.60, 0.95, Curves.easeInOut);

  Animation<double> _part(double a, double b, Curve curve) => CurvedAnimation(
    parent: _c,
    curve: Interval(a, b, curve: curve),
  );

  @override
  void initState() {
    super.initState();
    _c.addStatusListener((s) {
      if (s == AnimationStatus.completed) Future.delayed(const Duration(milliseconds: 180), _leave);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 움직임 줄이기를 켠 사용자에게는 바로 끝 모습
    if (MediaQuery.disableAnimationsOf(context)) {
      _c.value = 1;
    } else if (!_c.isAnimating && _c.value == 0) {
      _c.forward();
    }
  }

  void _leave() {
    if (_left || !mounted) return;
    _left = true;
    context.go(context.read<SettingsCubit>().state.guideSeen ? '/board' : '/guide');
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _leave,
        child: Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(0, -0.15),
              radius: 0.9,
              colors: [Color(0xFF101510), AppColors.bg],
            ),
          ),
          child: Center(
            child: AnimatedBuilder(
              animation: _c,
              builder: (context, _) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // 칩 뒤의 녹색 빛: 커졌다가 은은하게 남는다
                        Opacity(
                          opacity: (math.sin(_glow.value * math.pi) * 0.55 + _glow.value * 0.25).clamp(0, 1),
                          child: Container(
                            width: 70 + 30 * _glow.value,
                            height: 70 + 30 * _glow.value,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.accent.withValues(alpha: 0.6),
                                  blurRadius: 40,
                                  spreadRadius: 4,
                                ),
                              ],
                            ),
                          ),
                        ),
                        ChipLogo(size: 120, frame: _frame.value, pins: _pins.value, core: _core.value),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  Opacity(
                    opacity: _word.value,
                    child: Transform.translate(
                      offset: Offset(0, 10 * (1 - _word.value)),
                      child: const Wordmark(size: 34),
                    ),
                  ),
                  const SizedBox(height: 14),
                  CustomPaint(size: const Size(220, 44), painter: _TickPainter(_tick.value)),
                  const SizedBox(height: 14),
                  Opacity(
                    opacity: _tick.value,
                    child: Text(
                      t.launchSub,
                      style: const TextStyle(fontSize: 13, color: AppColors.muted, letterSpacing: 0.5),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 왼쪽에서 오른쪽으로 그어지는 시세 선과 끝점
class _TickPainter extends CustomPainter {
  _TickPainter(this.progress);
  final double progress;

  static const _pts = [
    Offset(2, 34), Offset(30, 30), Offset(52, 36), Offset(78, 22), Offset(100, 26), //
    Offset(126, 14), Offset(150, 20), Offset(176, 8), Offset(200, 12), Offset(218, 6),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0) return;
    final path = Path()..moveTo(_pts.first.dx, _pts.first.dy);
    for (final p in _pts.skip(1)) {
      path.lineTo(p.dx, p.dy);
    }
    final paint = Paint()
      ..color = AppColors.accent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    for (final m in path.computeMetrics()) {
      canvas.drawPath(m.extractPath(0, m.length * progress), paint);
    }
    if (progress >= 0.98) canvas.drawCircle(_pts.last, 3.5, Paint()..color = AppColors.accent);
  }

  @override
  bool shouldRepaint(_TickPainter old) => old.progress != progress;
}
