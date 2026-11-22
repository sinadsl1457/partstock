// 가격·등락·시각 글자와 상승·하락 색. 화면이 언어(ko/en)에 맞게 부른다.
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../features/market/data/market_models.dart';

bool isKo(BuildContext context) => Localizations.localeOf(context).languageCode == 'ko';

String usd(int cents) {
  final d = cents / 100;
  return NumberFormat.currency(locale: 'en_US', symbol: r'$', decimalDigits: d >= 100 ? 0 : 2).format(d);
}

/// 1,858,502원 → "185.9만원"
String krw(int cents, Fx fx) => '${NumberFormat('#,##0.0', 'ko').format(cents / 100 * fx.usdKrw / 10000)}만원';

/// 큰 글자(한국어는 원화, 영어는 달러)와 작은 글자(한국어일 때 달러)
({String big, String? small}) mainPrice(BuildContext context, int cents, Fx? fx) {
  if (isKo(context) && fx != null) return (big: krw(cents, fx), small: usd(cents));
  return (big: usd(cents), small: null);
}

String pct(double v) => '${v > 0 ? '+' : ''}${v.toStringAsFixed(2)}%';

/// 한국: 빨강 상승·파랑 하락, 영어권: 초록 상승·빨강 하락.
/// 영어권 상승 초록은 강조색(라임)과 헷갈리지 않게 청록 쪽으로 띄운다.
({Color up, Color down}) upDown(BuildContext context) => isKo(context)
    ? (up: const Color(0xFFFF6464), down: const Color(0xFF5C9DFF))
    : (up: const Color(0xFF34D399), down: const Color(0xFFFF6464));

const neutral = Color(0xFF8E978F);

Color changeColor(BuildContext context, double? v) {
  if (v == null || v == 0) return neutral;
  final c = upDown(context);
  return v > 0 ? c.up : c.down;
}

/// 시각: 폰의 시간대로
String timeText(BuildContext context, DateTime t) {
  final locale = Localizations.localeOf(context).toLanguageTag();
  return DateFormat.MMMd(locale).add_jm().format(t.toLocal());
}
