// 설정(앱 전체 수명): 바로가기 기본값(종목 화면 버튼 순서), 가이드를 봤는지(런치 다음에 가이드를 띄울지).
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../data/settings_repository.dart';

typedef SettingsState = ({Jump jump, bool guideSeen});

@lazySingleton
class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit(this._repo) : super((jump: _repo.jump(), guideSeen: _repo.guideSeen()));

  final SettingsRepository _repo;

  Future<void> setJump(Jump j) async {
    emit((jump: j, guideSeen: state.guideSeen));
    await _repo.setJump(j);
  }

  Future<void> markGuideSeen() async {
    emit((jump: state.jump, guideSeen: true));
    await _repo.setGuideSeen();
  }
}
