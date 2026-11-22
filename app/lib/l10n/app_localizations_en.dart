// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get tabBoard => 'Prices';

  @override
  String get tabWatch => 'Watchlist';

  @override
  String get tabSettings => 'Settings';

  @override
  String get boardTitle => 'Prices';

  @override
  String get gpu => 'GPU';

  @override
  String get ram => 'RAM';

  @override
  String get colName => 'Item';

  @override
  String get colPrice => 'Price · 24H';

  @override
  String updatedAt(String time) {
    return 'As of $time · hourly';
  }

  @override
  String listingsShort(int n) {
    return '$n listings';
  }

  @override
  String listings(int n) {
    return '$n listings';
  }

  @override
  String get tooFew => 'No data';

  @override
  String get boardNote =>
      'Price = 25th percentile of new, Buy It Now listings on eBay US. Shipping and tax not included.';

  @override
  String get vendorNvidia => 'NVIDIA';

  @override
  String get vendorAmd => 'AMD';

  @override
  String get vendorDesktop => 'Desktop';

  @override
  String change24h(String pct) {
    return '24h $pct';
  }

  @override
  String priceHint(String median) {
    return '25th pct. · median $median';
  }

  @override
  String rangeChange(String range) {
    return '$range change';
  }

  @override
  String get high => 'High';

  @override
  String get low => 'Low';

  @override
  String get line => 'Line';

  @override
  String get candle => 'Candles';

  @override
  String get range1d => '1D';

  @override
  String get range1w => '1W';

  @override
  String get range1m => '1M';

  @override
  String get range3m => '3M';

  @override
  String get range1y => '1Y';

  @override
  String get rangeAll => 'All';

  @override
  String get bucket1h => '1h candles';

  @override
  String get bucket4h => '4h candles';

  @override
  String get bucket1d => 'Daily';

  @override
  String get bucket7d => 'Weekly';

  @override
  String collecting(String since, int n) {
    return 'Collecting hourly since $since · $n so far';
  }

  @override
  String get noChart => 'No prices to chart yet.';

  @override
  String get makers => 'By brand';

  @override
  String get models => 'By model';

  @override
  String get modelsNote => 'Shown with 5+ listings';

  @override
  String get viewOnEbay => 'View on eBay';

  @override
  String get danawa => 'Danawa';

  @override
  String get watchTitle => 'Watchlist';

  @override
  String get watchEmpty => 'Nothing here yet.\nTap the star on an item\'s chart to add it.';

  @override
  String get addWatch => 'Add to watchlist';

  @override
  String get removeWatch => 'Remove from watchlist';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get jumpDefault => 'Open listings in';

  @override
  String get jumpDefaultHint => 'The dark button on an item opens here.';

  @override
  String get errorNetwork => 'Can\'t connect to the internet.';

  @override
  String get errorServer => 'The price server has a problem. Please try again shortly.';

  @override
  String get errorNotFound => 'No such item.';

  @override
  String get showingSaved => 'Showing saved prices';

  @override
  String get retry => 'Retry';

  @override
  String get back => 'Back';

  @override
  String get source => 'Prices: eBay US';

  @override
  String get alertTitle => 'Price alert';

  @override
  String get alertBelow => 'Falls to or below';

  @override
  String get alertAbove => 'Rises to or above';

  @override
  String get alertTargetKo => 'Target (만원)';

  @override
  String get alertTargetUsd => 'Target price (\$)';

  @override
  String alertLower(String pct) {
    return '$pct% below now';
  }

  @override
  String alertHigher(String pct) {
    return '$pct% above now';
  }

  @override
  String alertNow(String price) {
    return 'Now $price';
  }

  @override
  String get alertNote =>
      'Checked right after each hourly update using the 25th-percentile price. Fires once, then turns off.';

  @override
  String get alertSave => 'Turn on alert';

  @override
  String get alertSaved => 'Alert is on';

  @override
  String get alertDeleted => 'Alert removed';

  @override
  String get alertLimit => 'Up to 20 waiting alerts';

  @override
  String get alertDenied => 'Notifications are off. Turn them on for partstock in phone settings.';

  @override
  String get alertNotReady => 'Alerts are getting ready. Try again shortly.';

  @override
  String get alertsSection => 'Price alerts';

  @override
  String condBelow(String target) {
    return '≤ $target';
  }

  @override
  String condAbove(String target) {
    return '≥ $target';
  }

  @override
  String alertFired(String price) {
    return 'Fired · $price';
  }

  @override
  String get alertDelete => 'Remove alert';

  @override
  String get alertInvalid => 'Enter a number';

  @override
  String get alertAlreadyMet => 'Already met — fires at the next hourly update';

  @override
  String updatedPill(String time) {
    return 'Updated $time';
  }

  @override
  String get launchSub => 'GPU · RAM · CPU · SSD prices';

  @override
  String get guideSkip => 'Skip';

  @override
  String get guideNext => 'Next';

  @override
  String get guideStartPush => 'Allow alerts & start';

  @override
  String get guideStart => 'Get started';

  @override
  String get guideLater => 'Later';

  @override
  String get guidePrev => 'Back';

  @override
  String get guide1Title => 'PC part prices\nat a glance';

  @override
  String get guide1Body =>
      'We collect new eBay US listings every hour and show what you can actually buy each chip for.';

  @override
  String get guide1Badge => '25th pct. of new eBay listings';

  @override
  String get guide2Title => 'Tap for charts,\ndrill into models';

  @override
  String get guide2Body =>
      'See 1D to all-time in lines or candles, compare brands and models, then jump to eBay or Danawa.';

  @override
  String get guide3Title => 'We\'ll tell you when\nthe price is right';

  @override
  String get guide3Body => 'Set a target with the bell on any item. We check every hour and push you when it hits.';

  @override
  String get guide3Demo => 'RTX 5070 Ti hit your target';

  @override
  String get guide3DemoBody => 'Now \$1,350 · target ≤ \$1,360';

  @override
  String get sectionJump => 'Open listings in';

  @override
  String get sectionAlerts => 'Alerts';

  @override
  String get pushStatus => 'Push notifications';

  @override
  String get pushOn => 'On';

  @override
  String get pushOff => 'Off';

  @override
  String get pushUnsupported => 'Not on this device yet';

  @override
  String get pushHint => 'Change in phone settings';

  @override
  String get alertsCount => 'Price alerts';

  @override
  String alertsCountValue(String n) {
    return '$n';
  }

  @override
  String get sectionBasis => 'How prices work';

  @override
  String get basisPriceLabel => 'Price';

  @override
  String get basisPrice => '25th percentile of new, Buy It Now listings on eBay US';

  @override
  String get basisFxLabel => 'Currency';

  @override
  String get basisFx => 'Shown in USD · shipping and tax not included';

  @override
  String get basisUpdateLabel => 'Updates';

  @override
  String get basisUpdate => 'Every hour';

  @override
  String get sectionHelp => 'Help';

  @override
  String get guideAgain => 'Show guide again';

  @override
  String get appVersion => 'Version';

  @override
  String get categoryVga => 'GPU';

  @override
  String get categoryRam => 'RAM';

  @override
  String get filter => 'Filter';

  @override
  String filterTitle(String category) {
    return '$category filter';
  }

  @override
  String get filterReset => 'Reset';

  @override
  String filterApply(int count) {
    return 'Show $count items';
  }

  @override
  String get filter_series => 'Series';

  @override
  String get filter_ddr => 'Generation';

  @override
  String get filter_pack => 'Pack';

  @override
  String get pack_1 => 'Single';

  @override
  String get pack_2 => '2-stick kit';

  @override
  String get filterAll => 'All';

  @override
  String get filterEmpty => 'No items match';

  @override
  String get filterHintMulti => 'Pick any. None picked means all';

  @override
  String get cpu => 'CPU';

  @override
  String get vendorIntel => 'Intel';

  @override
  String get filter_brand => 'Brand';

  @override
  String coreGen(String gen) {
    return 'Core ${gen}th Gen';
  }

  @override
  String get ssd => 'SSD';

  @override
  String get filter_capacity => 'Capacity';

  @override
  String get filter_iface => 'Interface';

  @override
  String get privacy => 'Privacy policy';
}
