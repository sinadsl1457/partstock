// 관심 종목(앱 전체 수명). 종목 차트의 별과 관심 탭이 같은 상태를 본다. 상태 = 키 목록.
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../data/watchlist_repository.dart';

@lazySingleton
class WatchlistCubit extends Cubit<List<String>> {
  WatchlistCubit(this._repo) : super(_repo.load());

  final WatchlistRepository _repo;

  Future<void> toggle(String key) async {
    final next = state.contains(key) ? (List.of(state)..remove(key)) : [...state, key];
    emit(next);
    await _repo.save(next);
  }
}
