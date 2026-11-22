// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:get_it/get_it.dart' as _i174;
import 'package:http/http.dart' as _i519;
import 'package:injectable/injectable.dart' as _i526;
import 'package:partstock/core/di/app_module.dart' as _i917;
import 'package:partstock/core/network/api_client.dart' as _i968;
import 'package:partstock/core/push/push_service.dart' as _i893;
import 'package:partstock/core/time/clock.dart' as _i739;
import 'package:partstock/features/alerts/data/alerts_repository.dart' as _i208;
import 'package:partstock/features/alerts/presentation/alerts_cubit.dart'
    as _i412;
import 'package:partstock/features/board/data/board_filter_repository.dart'
    as _i45;
import 'package:partstock/features/board/presentation/board_cubit.dart'
    as _i772;
import 'package:partstock/features/market/data/market_repository.dart' as _i261;
import 'package:partstock/features/settings/data/settings_repository.dart'
    as _i115;
import 'package:partstock/features/settings/presentation/settings_cubit.dart'
    as _i947;
import 'package:partstock/features/ticker/presentation/ticker_cubit.dart'
    as _i527;
import 'package:partstock/features/watchlist/data/watchlist_repository.dart'
    as _i348;
import 'package:partstock/features/watchlist/presentation/watch_prices_cubit.dart'
    as _i269;
import 'package:partstock/features/watchlist/presentation/watchlist_cubit.dart'
    as _i768;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final appModule = _$AppModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => appModule.prefs,
      preResolve: true,
    );
    gh.lazySingleton<_i519.Client>(() => appModule.httpClient);
    gh.lazySingleton<_i739.Clock>(() => appModule.clock);
    gh.lazySingleton<_i893.PushService>(() => _i893.FirebasePushService());
    gh.factory<String>(() => appModule.apiUrl, instanceName: 'apiUrl');
    gh.lazySingleton<_i45.BoardFilterRepository>(
      () => _i45.BoardFilterRepository(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i115.SettingsRepository>(
      () => _i115.SettingsRepository(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i348.WatchlistRepository>(
      () => _i348.WatchlistRepository(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i968.ApiClient>(
      () => _i968.ApiClient(
        gh<_i519.Client>(),
        gh<String>(instanceName: 'apiUrl'),
      ),
    );
    gh.lazySingleton<_i261.MarketRepository>(
      () => _i261.MarketRepository(
        gh<_i968.ApiClient>(),
        gh<_i460.SharedPreferences>(),
      ),
    );
    gh.lazySingleton<_i208.AlertsRepository>(
      () => _i208.AlertsRepository(gh<_i968.ApiClient>()),
    );
    gh.factoryParam<_i527.TickerCubit, String, dynamic>(
      (key, _) => _i527.TickerCubit(gh<_i261.MarketRepository>(), key),
    );
    gh.lazySingleton<_i412.AlertsCubit>(
      () => _i412.AlertsCubit(
        gh<_i893.PushService>(),
        gh<_i208.AlertsRepository>(),
      ),
    );
    gh.lazySingleton<_i947.SettingsCubit>(
      () => _i947.SettingsCubit(gh<_i115.SettingsRepository>()),
    );
    gh.factory<_i269.WatchPricesCubit>(
      () => _i269.WatchPricesCubit(gh<_i261.MarketRepository>()),
    );
    gh.lazySingleton<_i768.WatchlistCubit>(
      () => _i768.WatchlistCubit(gh<_i348.WatchlistRepository>()),
    );
    gh.factory<_i772.BoardCubit>(
      () => _i772.BoardCubit(
        gh<_i261.MarketRepository>(),
        gh<_i45.BoardFilterRepository>(),
      ),
    );
    return this;
  }
}

class _$AppModule extends _i917.AppModule {}
