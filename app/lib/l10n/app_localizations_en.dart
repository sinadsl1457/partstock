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
  String get gpu => 'Graphics cards';

  @override
  String get ram => 'Memory';

  @override
  String get colName => 'Item';

  @override
  String get colPrice => 'Price · 24h';

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
  String get tooFew => 'Too few';

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
}
