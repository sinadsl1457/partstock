// 서버 호출 실패 종류. 화면은 이걸 보고 다른 안내를 띄운다(연결 문제 vs 서버 문제).
sealed class AppFailure implements Exception {
  const AppFailure();
}

/// 인터넷 연결 실패·시간 초과
class NetworkFailure extends AppFailure {
  const NetworkFailure();
}

/// 서버가 오류를 돌려줌(5xx 등)
class ServerFailure extends AppFailure {
  const ServerFailure(this.status);
  final int status;
}

/// 없는 종목
class NotFoundFailure extends AppFailure {
  const NotFoundFailure();
}
