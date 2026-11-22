// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get tabBoard => '시세';

  @override
  String get tabWatch => '관심';

  @override
  String get tabSettings => '설정';

  @override
  String get boardTitle => '시세';

  @override
  String get gpu => '그래픽카드';

  @override
  String get ram => '램';

  @override
  String get colName => '종목';

  @override
  String get colPrice => '대표가 · 24시간';

  @override
  String updatedAt(String time) {
    return '$time 기준 · 매시간';
  }

  @override
  String listingsShort(int n) {
    return '글 $n';
  }

  @override
  String listings(int n) {
    return '판매 글 $n개';
  }

  @override
  String get tooFew => '글 부족';

  @override
  String get boardNote => '대표가 = 미국 eBay 새 상품·즉시 구매 글의 하위 25%. 원화는 기준 환율 환산, 배송비·관세 제외.';

  @override
  String get vendorNvidia => 'NVIDIA';

  @override
  String get vendorAmd => 'AMD';

  @override
  String get vendorDesktop => '데스크톱용';

  @override
  String change24h(String pct) {
    return '24시간 $pct';
  }

  @override
  String priceHint(String median) {
    return '하위 25% · 중앙값 $median';
  }

  @override
  String rangeChange(String range) {
    return '$range 등락';
  }

  @override
  String get high => '최고';

  @override
  String get low => '최저';

  @override
  String get line => '선';

  @override
  String get candle => '봉';

  @override
  String get range1d => '1일';

  @override
  String get range1w => '1주';

  @override
  String get range1m => '1달';

  @override
  String get range3m => '3달';

  @override
  String get range1y => '1년';

  @override
  String get rangeAll => '전체';

  @override
  String get bucket1h => '1시간 봉';

  @override
  String get bucket4h => '4시간 봉';

  @override
  String get bucket1d => '일봉';

  @override
  String get bucket7d => '주봉';

  @override
  String collecting(String since, int n) {
    return '$since부터 매시간 쌓는 중 · 지금 $n개';
  }

  @override
  String get noChart => '아직 차트로 그릴 시세가 없습니다.';

  @override
  String get makers => '제조사별';

  @override
  String get models => '모델별';

  @override
  String get modelsNote => '판매 글 5개 이상일 때만 시세';

  @override
  String get viewOnEbay => 'eBay에서 보기';

  @override
  String get danawa => '다나와';

  @override
  String get watchTitle => '관심';

  @override
  String get watchEmpty => '관심 종목이 없습니다.\n종목 차트 오른쪽 위 별을 눌러 추가하세요.';

  @override
  String get addWatch => '관심 종목에 추가';

  @override
  String get removeWatch => '관심 종목에서 빼기';

  @override
  String get settingsTitle => '설정';

  @override
  String get jumpDefault => '바로가기 기본';

  @override
  String get jumpDefaultHint => '종목 화면 아래 진한 버튼이 이쪽으로 열립니다.';

  @override
  String get errorNetwork => '인터넷에 연결할 수 없습니다.';

  @override
  String get errorServer => '시세 서버에 문제가 있습니다. 잠시 뒤 다시 시도해 주세요.';

  @override
  String get errorNotFound => '없는 종목입니다.';

  @override
  String get showingSaved => '저장된 시세를 보여 주는 중';

  @override
  String get retry => '다시 시도';

  @override
  String get back => '뒤로';

  @override
  String get source => '가격: eBay(미국) · 환율: 유럽중앙은행 기준 환율';
}
