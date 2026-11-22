# partstock 앱 (Flutter)

전체 설명·화면·실행 방법은 [루트 README](../README.md).

```bash
flutter pub get
flutter test
flutter run    # 로컬 서버: --dart-define=API_URL=http://10.0.2.2:8080
```

구조: Cubit(flutter_bloc) + get_it/injectable + go_router, 기능 폴더 `lib/features/*`. 규칙은 [`../CLAUDE.md`](../CLAUDE.md)의 앱 절.
