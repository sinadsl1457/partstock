// 지금 시각. DateTime.now()를 직접 부르지 않고 이걸 주입받는다(테스트에서 시각 고정).
abstract interface class Clock {
  DateTime now();
}

class SystemClock implements Clock {
  @override
  DateTime now() => DateTime.now();
}
