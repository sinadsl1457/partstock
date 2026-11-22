// 칩 모양 로고와 글자 로고. 런치 애니메이션이 단계별로 그리도록 진행도(0~1)를 받는다.
import 'package:flutter/material.dart';

import 'theme.dart';

/// frame·pins·core: 각 부분이 그려진 정도(0~1). 정지 로고는 모두 1.
class ChipLogo extends StatelessWidget {
  const ChipLogo({super.key, this.size = 28, this.frame = 1, this.pins = 1, this.core = 1});

  final double size;
  final double frame;
  final double pins;
  final double core;

  @override
  Widget build(BuildContext context) => CustomPaint(
    size: Size.square(size),
    painter: _ChipPainter(frame: frame, pins: pins, core: core),
  );
}

class _ChipPainter extends CustomPainter {
  _ChipPainter({required this.frame, required this.pins, required this.core});
  final double frame, pins, core;

  @override
  void paint(Canvas canvas, Size size) {
    final u = size.width / 28; // 시안의 28칸 격자 기준
    final stroke = Paint()
      ..color = AppColors.accent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.7 * u
      ..strokeCap = StrokeCap.round;

    // 테두리: 경로를 frame 비율만큼만 그린다
    final rect = RRect.fromRectAndRadius(Rect.fromLTWH(6 * u, 6 * u, 16 * u, 16 * u), Radius.circular(3 * u));
    final path = Path()..addRRect(rect);
    for (final m in path.computeMetrics()) {
      canvas.drawPath(m.extractPath(0, m.length * frame.clamp(0, 1)), stroke);
    }

    // 핀 12개: 위·아래·왼쪽·오른쪽 순서로 바깥에서 안쪽으로 자란다
    final pin = Paint()
      ..color = AppColors.accent
      ..strokeWidth = 1.5 * u
      ..strokeCap = StrokeCap.round;
    const lanes = [10.0, 14.0, 18.0];
    for (var side = 0; side < 4; side++) {
      final t = ((pins * 4) - side).clamp(0.0, 1.0);
      if (t == 0) continue;
      for (final p in lanes) {
        final (a, b) = switch (side) {
          0 => (Offset(p, 1), Offset(p, 1 + 4.5 * t)),
          1 => (Offset(p, 27), Offset(p, 27 - 4.5 * t)),
          2 => (Offset(1, p), Offset(1 + 4.5 * t, p)),
          _ => (Offset(27, p), Offset(27 - 4.5 * t, p)),
        };
        canvas.drawLine(a * u, b * u, pin);
      }
    }

    // 가운데 칩: 0→1.25→1로 톡 튀어나온다
    if (core > 0) {
      final s = core < 0.7 ? core / 0.7 * 1.25 : 1.25 - (core - 0.7) / 0.3 * 0.25;
      final half = 3.5 * u * s;
      final c = Offset(14 * u, 14 * u);
      canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromCenter(center: c, width: half * 2, height: half * 2), Radius.circular(u)),
        Paint()..color = AppColors.accent,
      );
    }
  }

  @override
  bool shouldRepaint(_ChipPainter old) => old.frame != frame || old.pins != pins || old.core != core;
}

/// "part" + 녹색 "stock"
class Wordmark extends StatelessWidget {
  const Wordmark({super.key, this.size = 22});
  final double size;

  @override
  Widget build(BuildContext context) => Text.rich(
    TextSpan(
      text: 'part',
      children: const [
        TextSpan(
          text: 'stock',
          style: TextStyle(color: AppColors.accent),
        ),
      ],
    ),
    style: TextStyle(fontSize: size, fontWeight: FontWeight.w700, letterSpacing: -0.02 * size, color: AppColors.text),
  );
}

/// 빛나는 작은 점(업데이트 표시·알림 켜짐)
class GlowDot extends StatelessWidget {
  const GlowDot({super.key, this.size = 7});
  final double size;

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: const BoxDecoration(
      color: AppColors.accent,
      shape: BoxShape.circle,
      boxShadow: [BoxShadow(color: AppColors.accent, blurRadius: 8)],
    ),
  );
}

/// 시안의 녹색 밑줄 탭(VGA / RAM, 제조사별 / 모델별)
class UnderlineTabs<T> extends StatelessWidget {
  const UnderlineTabs({
    super.key,
    required this.items,
    required this.selected,
    required this.onSelect,
    this.fontSize = 15,
  });

  final List<(T, String)> items;
  final T selected;
  final ValueChanged<T> onSelect;
  final double fontSize;

  @override
  Widget build(BuildContext context) => Container(
    decoration: const BoxDecoration(
      border: Border(bottom: BorderSide(color: AppColors.line)),
    ),
    child: Row(
      children: [
        for (final (value, label) in items)
          Padding(
            padding: const EdgeInsets.only(right: 22),
            child: InkWell(
              onTap: () => onSelect(value),
              child: Container(
                constraints: const BoxConstraints(minHeight: 44),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: value == selected ? AppColors.accent : Colors.transparent, width: 2),
                  ),
                ),
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: value == selected ? FontWeight.w700 : FontWeight.w500,
                    color: value == selected ? AppColors.text : AppColors.muted,
                  ),
                ),
              ),
            ),
          ),
      ],
    ),
  );
}

/// 기간 버튼처럼 칸을 나눠 고르는 알약 버튼 줄
class PillGroup<T> extends StatelessWidget {
  const PillGroup({super.key, required this.items, required this.selected, required this.onSelect});

  final List<(T, String)> items;
  final T selected;
  final ValueChanged<T> onSelect;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      for (final (i, (value, label)) in items.indexed) ...[
        if (i > 0) const SizedBox(width: 4),
        Expanded(
          child: Semantics(
            selected: value == selected,
            button: true,
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () => onSelect(value),
              child: Container(
                height: 38,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: value == selected ? AppColors.accent : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: value == selected ? AppColors.accent : AppColors.line),
                ),
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: value == selected ? FontWeight.w700 : FontWeight.w500,
                    color: value == selected ? AppColors.onAccent : AppColors.sub,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    ],
  );
}

/// 둥근 카드(시안의 #121513 + 테두리)
class Panel extends StatelessWidget {
  const Panel({super.key, required this.child, this.padding = const EdgeInsets.all(14)});
  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) => Container(
    padding: padding,
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: AppColors.line),
    ),
    child: child,
  );
}

/// 판매처 꼬리표(NVIDIA·AMD·DESKTOP)
class Tag extends StatelessWidget {
  const Tag(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
    decoration: BoxDecoration(
      border: Border.all(color: AppColors.lineHi),
      borderRadius: BorderRadius.circular(4),
    ),
    child: Text(
      text,
      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 0.6, color: AppColors.sub),
    ),
  );
}
