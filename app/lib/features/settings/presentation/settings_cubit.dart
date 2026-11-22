// 바로가기 기본값(앱 전체 수명). 종목 화면 아래 버튼 순서가 이걸 따른다.
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../data/settings_repository.dart';

@lazySingleton
class SettingsCubit extends Cubit<Jump> {
  SettingsCubit(this._repo) : super(_repo.jump());

  final SettingsRepository _repo;

  Future<void> setJump(Jump j) async {
    emit(j);
    await _repo.setJump(j);
  }
}
