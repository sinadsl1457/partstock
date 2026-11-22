// 목표가 창: 설명 글자는 고른 방향이 아니라 실제 숫자 비교로, 이미 조건에 맞으면 바로 울린다고 알린다.
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:partstock/features/alerts/presentation/alert_sheet.dart';
import 'package:partstock/features/alerts/presentation/alerts_cubit.dart';
import 'package:partstock/l10n/app_localizations.dart';

import '../helpers/fakes.dart';

void main() {
  Future<void> open(WidgetTester tester) async {
    final cubit = AlertsCubit(FakePush(), MockAlertsRepo());
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('ko'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: BlocProvider.value(
            value: cubit,
            // 지금 187.5만원(1,300원 기준 144,231센트)
            child: const AlertSheet(tickerKey: 'rtx-5070-ti', nowCents: 144231, units: AlertUnits(1300)),
          ),
        ),
      ),
    );
  }

  testWidgets('이상으로 오르면 + 지금보다 낮은 값: 낮은 가격이라 쓰고 바로 울린다고 알린다', (tester) async {
    final semantics = tester.ensureSemantics();
    await open(tester);
    await tester.tap(find.textContaining('이상으로 오르면'));
    await tester.pump();
    await tester.enterText(find.byType(TextField), '180.0');
    await tester.pump();

    expect(find.text('지금보다 4.0% 낮은 가격'), findsOneWidget);
    expect(find.text('이미 조건에 맞아 다음 정각 수집 때 바로 울립니다'), findsOneWidget);
    // 손으로 넣으면 빠른 % 버튼 선택은 풀린다(화면 읽기 프로그램이 읽는 "선택됨" 표시로 확인)
    expect(tester.getSemantics(find.text('+5%')), isNot(containsSemantics(isSelected: true)));
    await tester.tap(find.text('+10%'));
    await tester.pump();
    expect(tester.getSemantics(find.text('+10%')), containsSemantics(isSelected: true, isButton: true));
    semantics.dispose();
  });

  testWidgets('기본(이하, −5%)은 낮은 가격이고 경고 없음', (tester) async {
    await open(tester);
    expect(find.text('지금보다 5.0% 낮은 가격'), findsOneWidget);
    expect(find.text('이미 조건에 맞아 다음 정각 수집 때 바로 울립니다'), findsNothing);
  });
}
