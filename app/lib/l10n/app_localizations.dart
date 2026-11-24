import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ko.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en'), Locale('ko')];

  /// No description provided for @tabBoard.
  ///
  /// In ko, this message translates to:
  /// **'시세'**
  String get tabBoard;

  /// No description provided for @tabWatch.
  ///
  /// In ko, this message translates to:
  /// **'관심'**
  String get tabWatch;

  /// No description provided for @tabSettings.
  ///
  /// In ko, this message translates to:
  /// **'설정'**
  String get tabSettings;

  /// No description provided for @boardTitle.
  ///
  /// In ko, this message translates to:
  /// **'시세'**
  String get boardTitle;

  /// No description provided for @gpu.
  ///
  /// In ko, this message translates to:
  /// **'VGA'**
  String get gpu;

  /// No description provided for @ram.
  ///
  /// In ko, this message translates to:
  /// **'RAM'**
  String get ram;

  /// No description provided for @colName.
  ///
  /// In ko, this message translates to:
  /// **'종목 · 미국 eBay 기준'**
  String get colName;

  /// No description provided for @colPrice.
  ///
  /// In ko, this message translates to:
  /// **'대표가 · 24H'**
  String get colPrice;

  /// No description provided for @updatedAt.
  ///
  /// In ko, this message translates to:
  /// **'{time} 기준 · 매시간'**
  String updatedAt(String time);

  /// No description provided for @listingsShort.
  ///
  /// In ko, this message translates to:
  /// **'글 {n}'**
  String listingsShort(int n);

  /// No description provided for @listings.
  ///
  /// In ko, this message translates to:
  /// **'판매 글 {n}개'**
  String listings(int n);

  /// No description provided for @tooFew.
  ///
  /// In ko, this message translates to:
  /// **'데이터 없음'**
  String get tooFew;

  /// No description provided for @boardNote.
  ///
  /// In ko, this message translates to:
  /// **'대표가 = 미국 eBay 새 상품·즉시 구매 글 가격의 하위 10%(글이 20개 미만이면 하위 25%). 원화는 기준 환율 환산, 배송비·관세 제외.'**
  String get boardNote;

  /// No description provided for @vendorNvidia.
  ///
  /// In ko, this message translates to:
  /// **'NVIDIA'**
  String get vendorNvidia;

  /// No description provided for @vendorAmd.
  ///
  /// In ko, this message translates to:
  /// **'AMD'**
  String get vendorAmd;

  /// No description provided for @vendorDesktop.
  ///
  /// In ko, this message translates to:
  /// **'데스크톱용'**
  String get vendorDesktop;

  /// No description provided for @change24h.
  ///
  /// In ko, this message translates to:
  /// **'24시간 {pct}'**
  String change24h(String pct);

  /// No description provided for @priceHint.
  ///
  /// In ko, this message translates to:
  /// **'하위 {pct}% · 중앙값 {median}'**
  String priceHint(int pct, String median);

  /// No description provided for @rangeChange.
  ///
  /// In ko, this message translates to:
  /// **'{range} 등락'**
  String rangeChange(String range);

  /// No description provided for @high.
  ///
  /// In ko, this message translates to:
  /// **'최고'**
  String get high;

  /// No description provided for @low.
  ///
  /// In ko, this message translates to:
  /// **'최저'**
  String get low;

  /// No description provided for @line.
  ///
  /// In ko, this message translates to:
  /// **'선'**
  String get line;

  /// No description provided for @candle.
  ///
  /// In ko, this message translates to:
  /// **'봉'**
  String get candle;

  /// No description provided for @range1d.
  ///
  /// In ko, this message translates to:
  /// **'1일'**
  String get range1d;

  /// No description provided for @range1w.
  ///
  /// In ko, this message translates to:
  /// **'1주'**
  String get range1w;

  /// No description provided for @range1m.
  ///
  /// In ko, this message translates to:
  /// **'1달'**
  String get range1m;

  /// No description provided for @range3m.
  ///
  /// In ko, this message translates to:
  /// **'3달'**
  String get range3m;

  /// No description provided for @range1y.
  ///
  /// In ko, this message translates to:
  /// **'1년'**
  String get range1y;

  /// No description provided for @rangeAll.
  ///
  /// In ko, this message translates to:
  /// **'전체'**
  String get rangeAll;

  /// No description provided for @bucket1h.
  ///
  /// In ko, this message translates to:
  /// **'1시간 봉'**
  String get bucket1h;

  /// No description provided for @bucket4h.
  ///
  /// In ko, this message translates to:
  /// **'4시간 봉'**
  String get bucket4h;

  /// No description provided for @bucket1d.
  ///
  /// In ko, this message translates to:
  /// **'일봉'**
  String get bucket1d;

  /// No description provided for @bucket7d.
  ///
  /// In ko, this message translates to:
  /// **'주봉'**
  String get bucket7d;

  /// No description provided for @collecting.
  ///
  /// In ko, this message translates to:
  /// **'{since}부터 매시간 쌓는 중 · 지금 {n}개'**
  String collecting(String since, int n);

  /// No description provided for @noChart.
  ///
  /// In ko, this message translates to:
  /// **'아직 차트로 그릴 시세가 없습니다.'**
  String get noChart;

  /// No description provided for @makers.
  ///
  /// In ko, this message translates to:
  /// **'제조사별'**
  String get makers;

  /// No description provided for @models.
  ///
  /// In ko, this message translates to:
  /// **'모델별'**
  String get models;

  /// No description provided for @modelsNote.
  ///
  /// In ko, this message translates to:
  /// **'판매 글 5개 이상일 때만 시세'**
  String get modelsNote;

  /// No description provided for @viewOnEbay.
  ///
  /// In ko, this message translates to:
  /// **'eBay에서 보기'**
  String get viewOnEbay;

  /// No description provided for @danawa.
  ///
  /// In ko, this message translates to:
  /// **'다나와'**
  String get danawa;

  /// No description provided for @watchTitle.
  ///
  /// In ko, this message translates to:
  /// **'관심'**
  String get watchTitle;

  /// No description provided for @watchEmpty.
  ///
  /// In ko, this message translates to:
  /// **'관심 종목이 없습니다.\n종목 차트 오른쪽 위 별을 눌러 추가하세요.'**
  String get watchEmpty;

  /// No description provided for @addWatch.
  ///
  /// In ko, this message translates to:
  /// **'관심 종목에 추가'**
  String get addWatch;

  /// No description provided for @removeWatch.
  ///
  /// In ko, this message translates to:
  /// **'관심 종목에서 빼기'**
  String get removeWatch;

  /// No description provided for @settingsTitle.
  ///
  /// In ko, this message translates to:
  /// **'설정'**
  String get settingsTitle;

  /// No description provided for @jumpDefault.
  ///
  /// In ko, this message translates to:
  /// **'바로가기 기본'**
  String get jumpDefault;

  /// No description provided for @jumpDefaultHint.
  ///
  /// In ko, this message translates to:
  /// **'종목 화면 아래 진한 버튼이 이쪽으로 열립니다.'**
  String get jumpDefaultHint;

  /// No description provided for @errorNetwork.
  ///
  /// In ko, this message translates to:
  /// **'인터넷에 연결할 수 없습니다.'**
  String get errorNetwork;

  /// No description provided for @errorServer.
  ///
  /// In ko, this message translates to:
  /// **'시세 서버에 문제가 있습니다. 잠시 뒤 다시 시도해 주세요.'**
  String get errorServer;

  /// No description provided for @errorNotFound.
  ///
  /// In ko, this message translates to:
  /// **'없는 종목입니다.'**
  String get errorNotFound;

  /// No description provided for @showingSaved.
  ///
  /// In ko, this message translates to:
  /// **'저장된 시세를 보여 주는 중'**
  String get showingSaved;

  /// No description provided for @retry.
  ///
  /// In ko, this message translates to:
  /// **'다시 시도'**
  String get retry;

  /// No description provided for @back.
  ///
  /// In ko, this message translates to:
  /// **'뒤로'**
  String get back;

  /// No description provided for @source.
  ///
  /// In ko, this message translates to:
  /// **'가격: eBay(미국) · 환율: 유럽중앙은행 기준 환율'**
  String get source;

  /// No description provided for @alertTitle.
  ///
  /// In ko, this message translates to:
  /// **'목표가 알림'**
  String get alertTitle;

  /// No description provided for @alertBelow.
  ///
  /// In ko, this message translates to:
  /// **'이하로 내려가면'**
  String get alertBelow;

  /// No description provided for @alertAbove.
  ///
  /// In ko, this message translates to:
  /// **'이상으로 오르면'**
  String get alertAbove;

  /// No description provided for @alertTargetKo.
  ///
  /// In ko, this message translates to:
  /// **'목표 가격 (만원)'**
  String get alertTargetKo;

  /// No description provided for @alertTargetUsd.
  ///
  /// In ko, this message translates to:
  /// **'목표 가격 (\$)'**
  String get alertTargetUsd;

  /// No description provided for @alertLower.
  ///
  /// In ko, this message translates to:
  /// **'지금보다 {pct}% 낮은 가격'**
  String alertLower(String pct);

  /// No description provided for @alertHigher.
  ///
  /// In ko, this message translates to:
  /// **'지금보다 {pct}% 높은 가격'**
  String alertHigher(String pct);

  /// No description provided for @alertNow.
  ///
  /// In ko, this message translates to:
  /// **'지금 대표가 {price}'**
  String alertNow(String price);

  /// No description provided for @alertNote.
  ///
  /// In ko, this message translates to:
  /// **'매시간 수집 직후 대표가로 확인해서 푸시로 알려 드립니다. 한 번 울리면 꺼집니다.'**
  String get alertNote;

  /// No description provided for @alertSave.
  ///
  /// In ko, this message translates to:
  /// **'알림 켜기'**
  String get alertSave;

  /// No description provided for @alertSaved.
  ///
  /// In ko, this message translates to:
  /// **'알림을 켰습니다'**
  String get alertSaved;

  /// No description provided for @alertDeleted.
  ///
  /// In ko, this message translates to:
  /// **'알림을 지웠습니다'**
  String get alertDeleted;

  /// No description provided for @alertLimit.
  ///
  /// In ko, this message translates to:
  /// **'대기 중 알림은 20개까지입니다'**
  String get alertLimit;

  /// No description provided for @alertDenied.
  ///
  /// In ko, this message translates to:
  /// **'알림 권한이 꺼져 있습니다. 폰 설정에서 partstock 알림을 켜 주세요.'**
  String get alertDenied;

  /// No description provided for @alertNotReady.
  ///
  /// In ko, this message translates to:
  /// **'알림 준비 중입니다. 잠시 뒤 다시 시도해 주세요.'**
  String get alertNotReady;

  /// No description provided for @alertsSection.
  ///
  /// In ko, this message translates to:
  /// **'목표가 알림'**
  String get alertsSection;

  /// No description provided for @condBelow.
  ///
  /// In ko, this message translates to:
  /// **'{target} 이하'**
  String condBelow(String target);

  /// No description provided for @condAbove.
  ///
  /// In ko, this message translates to:
  /// **'{target} 이상'**
  String condAbove(String target);

  /// No description provided for @alertFired.
  ///
  /// In ko, this message translates to:
  /// **'울림 · {price}'**
  String alertFired(String price);

  /// No description provided for @alertDelete.
  ///
  /// In ko, this message translates to:
  /// **'알림 지우기'**
  String get alertDelete;

  /// No description provided for @alertInvalid.
  ///
  /// In ko, this message translates to:
  /// **'가격을 숫자로 넣어 주세요'**
  String get alertInvalid;

  /// No description provided for @alertAlreadyMet.
  ///
  /// In ko, this message translates to:
  /// **'이미 조건에 맞아 다음 정각 수집 때 바로 울립니다'**
  String get alertAlreadyMet;

  /// No description provided for @updatedPill.
  ///
  /// In ko, this message translates to:
  /// **'{time} 업데이트'**
  String updatedPill(String time);

  /// No description provided for @launchSub.
  ///
  /// In ko, this message translates to:
  /// **'VGA · RAM · CPU · SSD 시세'**
  String get launchSub;

  /// No description provided for @guideSkip.
  ///
  /// In ko, this message translates to:
  /// **'건너뛰기'**
  String get guideSkip;

  /// No description provided for @guideNext.
  ///
  /// In ko, this message translates to:
  /// **'다음'**
  String get guideNext;

  /// No description provided for @guideStartPush.
  ///
  /// In ko, this message translates to:
  /// **'알림 허용하고 시작'**
  String get guideStartPush;

  /// No description provided for @guideStart.
  ///
  /// In ko, this message translates to:
  /// **'시작하기'**
  String get guideStart;

  /// No description provided for @guideLater.
  ///
  /// In ko, this message translates to:
  /// **'나중에'**
  String get guideLater;

  /// No description provided for @guidePrev.
  ///
  /// In ko, this message translates to:
  /// **'이전'**
  String get guidePrev;

  /// No description provided for @guide1Title.
  ///
  /// In ko, this message translates to:
  /// **'내 부품, 지금\n얼마쯤일까?'**
  String get guide1Title;

  /// No description provided for @guide1Body.
  ///
  /// In ko, this message translates to:
  /// **'가진 그래픽카드가 지금 어느 정도 값인지, 사려는 부품이 오르는 중인지 내리는 중인지 한눈에 보여 드려요.'**
  String get guide1Body;

  /// No description provided for @guide1Badge.
  ///
  /// In ko, this message translates to:
  /// **'VGA·RAM·CPU·SSD 101개 종목 · 매시간 갱신'**
  String get guide1Badge;

  /// No description provided for @guide2Title.
  ///
  /// In ko, this message translates to:
  /// **'가격보다\n흐름을 보세요'**
  String get guide2Title;

  /// No description provided for @guide2Body.
  ///
  /// In ko, this message translates to:
  /// **'미국 eBay 새 상품 시세라 한국 실구매가와는 차이가 있어요. 대신 1일부터 전체까지 차트로 오르내림을 보고, 제조사·모델별로 비교할 수 있어요.'**
  String get guide2Body;

  /// No description provided for @guide3Title.
  ///
  /// In ko, this message translates to:
  /// **'원하는 가격이 되면\n알려 드려요'**
  String get guide3Title;

  /// No description provided for @guide3Body.
  ///
  /// In ko, this message translates to:
  /// **'종목 화면의 종 버튼으로 목표가를 걸어 두세요. 매시간 확인해서 닿으면 푸시로 알려 드려요.'**
  String get guide3Body;

  /// No description provided for @guide3Demo.
  ///
  /// In ko, this message translates to:
  /// **'RTX 5070 Ti 목표가 도달'**
  String get guide3Demo;

  /// No description provided for @guide3DemoBody.
  ///
  /// In ko, this message translates to:
  /// **'지금 179.8만원 · 목표 180.0만원 이하'**
  String get guide3DemoBody;

  /// No description provided for @sectionJump.
  ///
  /// In ko, this message translates to:
  /// **'바로가기 기본'**
  String get sectionJump;

  /// No description provided for @sectionAlerts.
  ///
  /// In ko, this message translates to:
  /// **'알림'**
  String get sectionAlerts;

  /// No description provided for @pushStatus.
  ///
  /// In ko, this message translates to:
  /// **'푸시 알림'**
  String get pushStatus;

  /// No description provided for @pushOn.
  ///
  /// In ko, this message translates to:
  /// **'켜짐'**
  String get pushOn;

  /// No description provided for @pushOff.
  ///
  /// In ko, this message translates to:
  /// **'꺼짐'**
  String get pushOff;

  /// No description provided for @pushUnsupported.
  ///
  /// In ko, this message translates to:
  /// **'이 기기는 아직 지원 안 함'**
  String get pushUnsupported;

  /// No description provided for @pushHint.
  ///
  /// In ko, this message translates to:
  /// **'끄고 켜기는 폰 설정에서'**
  String get pushHint;

  /// No description provided for @alertsCount.
  ///
  /// In ko, this message translates to:
  /// **'걸어 둔 목표가'**
  String get alertsCount;

  /// No description provided for @alertsCountValue.
  ///
  /// In ko, this message translates to:
  /// **'{n}개'**
  String alertsCountValue(String n);

  /// No description provided for @sectionBasis.
  ///
  /// In ko, this message translates to:
  /// **'가격 기준'**
  String get sectionBasis;

  /// No description provided for @basisPriceLabel.
  ///
  /// In ko, this message translates to:
  /// **'대표가'**
  String get basisPriceLabel;

  /// No description provided for @basisPrice.
  ///
  /// In ko, this message translates to:
  /// **'미국 eBay 새 상품·즉시 구매 글 가격의 하위 10%(글이 20개 미만이면 하위 25%)'**
  String get basisPrice;

  /// No description provided for @basisFxLabel.
  ///
  /// In ko, this message translates to:
  /// **'원화 환산'**
  String get basisFxLabel;

  /// No description provided for @basisFx.
  ///
  /// In ko, this message translates to:
  /// **'유럽중앙은행 기준 환율(그날 고시) · 배송비·관세 제외'**
  String get basisFx;

  /// No description provided for @basisUpdateLabel.
  ///
  /// In ko, this message translates to:
  /// **'갱신'**
  String get basisUpdateLabel;

  /// No description provided for @basisUpdate.
  ///
  /// In ko, this message translates to:
  /// **'매시간 정각'**
  String get basisUpdate;

  /// No description provided for @sectionHelp.
  ///
  /// In ko, this message translates to:
  /// **'도움말'**
  String get sectionHelp;

  /// No description provided for @guideAgain.
  ///
  /// In ko, this message translates to:
  /// **'가이드 다시 보기'**
  String get guideAgain;

  /// No description provided for @appVersion.
  ///
  /// In ko, this message translates to:
  /// **'앱 버전'**
  String get appVersion;

  /// No description provided for @categoryVga.
  ///
  /// In ko, this message translates to:
  /// **'VGA'**
  String get categoryVga;

  /// No description provided for @categoryRam.
  ///
  /// In ko, this message translates to:
  /// **'RAM'**
  String get categoryRam;

  /// No description provided for @filter.
  ///
  /// In ko, this message translates to:
  /// **'필터'**
  String get filter;

  /// No description provided for @filterTitle.
  ///
  /// In ko, this message translates to:
  /// **'{category} 필터'**
  String filterTitle(String category);

  /// No description provided for @filterReset.
  ///
  /// In ko, this message translates to:
  /// **'초기화'**
  String get filterReset;

  /// No description provided for @filterApply.
  ///
  /// In ko, this message translates to:
  /// **'{count}개 종목 보기'**
  String filterApply(int count);

  /// No description provided for @filter_series.
  ///
  /// In ko, this message translates to:
  /// **'시리즈'**
  String get filter_series;

  /// No description provided for @filter_ddr.
  ///
  /// In ko, this message translates to:
  /// **'세대'**
  String get filter_ddr;

  /// No description provided for @filter_pack.
  ///
  /// In ko, this message translates to:
  /// **'구성'**
  String get filter_pack;

  /// No description provided for @pack_1.
  ///
  /// In ko, this message translates to:
  /// **'1개'**
  String get pack_1;

  /// No description provided for @pack_2.
  ///
  /// In ko, this message translates to:
  /// **'2개 묶음'**
  String get pack_2;

  /// No description provided for @filterAll.
  ///
  /// In ko, this message translates to:
  /// **'전체'**
  String get filterAll;

  /// No description provided for @filterEmpty.
  ///
  /// In ko, this message translates to:
  /// **'조건에 맞는 종목이 없어요'**
  String get filterEmpty;

  /// No description provided for @filterHintMulti.
  ///
  /// In ko, this message translates to:
  /// **'여러 개 고를 수 있어요. 아무것도 안 고르면 전체'**
  String get filterHintMulti;

  /// No description provided for @cpu.
  ///
  /// In ko, this message translates to:
  /// **'CPU'**
  String get cpu;

  /// No description provided for @vendorIntel.
  ///
  /// In ko, this message translates to:
  /// **'Intel'**
  String get vendorIntel;

  /// No description provided for @filter_brand.
  ///
  /// In ko, this message translates to:
  /// **'브랜드'**
  String get filter_brand;

  /// No description provided for @coreGen.
  ///
  /// In ko, this message translates to:
  /// **'Core {gen}세대'**
  String coreGen(String gen);

  /// No description provided for @ssd.
  ///
  /// In ko, this message translates to:
  /// **'SSD'**
  String get ssd;

  /// No description provided for @filter_capacity.
  ///
  /// In ko, this message translates to:
  /// **'용량'**
  String get filter_capacity;

  /// No description provided for @filter_iface.
  ///
  /// In ko, this message translates to:
  /// **'규격'**
  String get filter_iface;

  /// No description provided for @privacy.
  ///
  /// In ko, this message translates to:
  /// **'개인정보 처리방침'**
  String get privacy;

  /// No description provided for @marketNote.
  ///
  /// In ko, this message translates to:
  /// **'미국 eBay 새 상품 기준 · 한국 실구매가와 다를 수 있어요(부가세·배송비 제외)'**
  String get marketNote;

  /// No description provided for @tabMovers.
  ///
  /// In ko, this message translates to:
  /// **'급등락'**
  String get tabMovers;

  /// No description provided for @moversUp.
  ///
  /// In ko, this message translates to:
  /// **'급등 TOP 5'**
  String get moversUp;

  /// No description provided for @moversDown.
  ///
  /// In ko, this message translates to:
  /// **'급락 TOP 5'**
  String get moversDown;

  /// No description provided for @moversVs.
  ///
  /// In ko, this message translates to:
  /// **'24시간 전 대비'**
  String get moversVs;

  /// No description provided for @moversNoneUp.
  ///
  /// In ko, this message translates to:
  /// **'24시간 동안 오른 종목이 없습니다.'**
  String get moversNoneUp;

  /// No description provided for @moversNoneDown.
  ///
  /// In ko, this message translates to:
  /// **'24시간 동안 내린 종목이 없습니다.'**
  String get moversNoneDown;

  /// No description provided for @moversNote.
  ///
  /// In ko, this message translates to:
  /// **'판매 글 {n}개 이상 종목만 · 4개 분류 전체 · 매시간 바뀝니다. 글이 적은 종목은 싼 글 하나로 크게 튀어서 뺍니다.'**
  String moversNote(int n);
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'ko'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ko':
      return AppLocalizationsKo();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
