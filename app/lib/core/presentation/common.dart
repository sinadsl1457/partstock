// 여러 화면이 같이 쓰는 작은 부품: 실패 안내, 미니 추이 그래프, 링크 열기, 글 수.
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../l10n/app_localizations.dart';
import '../network/app_failure.dart';
import 'theme.dart';

String failureText(BuildContext context, AppFailure f) {
  final t = AppLocalizations.of(context);
  return switch (f) {
    NetworkFailure() => t.errorNetwork,
    ServerFailure() => t.errorServer,
    NotFoundFailure() => t.errorNotFound,
  };
}

/// 처음 받기가 실패해 보여 줄 것이 없을 때
class FailureView extends StatelessWidget {
  const FailureView({super.key, required this.failure, required this.onRetry});

  final AppFailure failure;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(failureText(context, failure), textAlign: TextAlign.center),
            const SizedBox(height: 12),
            OutlinedButton(onPressed: onRetry, child: Text(AppLocalizations.of(context).retry)),
          ],
        ),
      ),
    );
  }
}

/// 목록 한 줄의 작은 추이. 두 점 미만이면 빈칸.
class Sparkline extends StatelessWidget {
  const Sparkline({super.key, required this.values, required this.color, this.size = const Size(52, 22)});

  final List<int> values;
  final Color color;
  final Size size;

  @override
  Widget build(BuildContext context) => SizedBox.fromSize(
    size: size,
    child: CustomPaint(painter: _SparkPainter(values, color)),
  );
}

class _SparkPainter extends CustomPainter {
  _SparkPainter(this.values, this.color);

  final List<int> values;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.length < 2) return;
    final min = values.reduce((a, b) => a < b ? a : b);
    final max = values.reduce((a, b) => a > b ? a : b);
    final span = (max - min) == 0 ? 1 : max - min;
    final path = Path();
    for (var i = 0; i < values.length; i++) {
      final x = i / (values.length - 1) * (size.width - 2) + 1;
      final y = size.height - 2 - (values[i] - min) / span * (size.height - 4);
      i == 0 ? path.moveTo(x, y) : path.lineTo(x, y);
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
  }

  @override
  bool shouldRepaint(_SparkPainter old) => old.values != values || old.color != color;
}

/// eBay·다나와 링크를 바깥 앱(브라우저 또는 그 앱)으로
Future<void> openLink(String url) => launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);

/// "글 9 · 표본 적음": 글이 적으면 대표가를 믿기 어렵다고 노란 글자로 붙인다(11/25, Ryzen 5 7600 글 9개로 다나와보다 9만원 비쌈)
InlineSpan listingsSpan(
  AppLocalizations t,
  int count,
  bool few, {
  TextStyle style = const TextStyle(fontSize: 11, color: AppColors.muted),
}) => TextSpan(
  style: style,
  children: [
    TextSpan(text: t.listingsShort(count)),
    if (few)
      TextSpan(
        text: ' · ${t.fewListings}',
        style: const TextStyle(color: AppColors.warn),
      ),
  ],
);
