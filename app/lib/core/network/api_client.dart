// 시세 API(Spring 서버) 호출. 저장소들만 부른다.
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

import 'app_failure.dart';

@lazySingleton
class ApiClient {
  ApiClient(this._http, @Named('apiUrl') this._base);

  final http.Client _http;
  final String _base;

  static const timeout = Duration(seconds: 10);

  Future<Map<String, dynamic>> get(String path, Map<String, String> query) async =>
      await send('GET', path, query: query) as Map<String, dynamic>;

  /// 응답 본문을 JSON으로 풀어서 돌려준다(본문이 없으면 null). 실패는 AppFailure로.
  Future<Object?> send(
    String method,
    String path, {
    Map<String, String>? query,
    Map<String, String>? headers,
    Object? body,
  }) async {
    // 조건이 없으면 주소 끝에 "?"를 붙이지 않는다
    final uri = Uri.parse(_base + path).replace(queryParameters: (query == null || query.isEmpty) ? null : query);
    http.Request request() {
      final req = http.Request(method, uri)..headers.addAll(headers ?? const {});
      if (body != null) {
        req.headers['Content-Type'] = 'application/json';
        req.body = jsonEncode(body);
      }
      return req;
    }

    // iOS는 백그라운드에 있는 동안 열어 둔 연결을 끊는다. 돌아오자마자 그 연결을 다시 쓰면 실패하므로
    // GET은 새 연결로 한 번만 다시 보낸다. POST·DELETE는 서버에 이미 닿았을 수 있어 다시 보내지 않는다.
    final res = await _fetch(request, retry: method == 'GET');
    if (res.statusCode == 404) throw const NotFoundFailure();
    if (res.statusCode < 200 || res.statusCode >= 300) throw ServerFailure(res.statusCode);
    if (res.bodyBytes.isEmpty) return null;
    return jsonDecode(utf8.decode(res.bodyBytes));
  }

  Future<http.Response> _fetch(http.Request Function() request, {required bool retry}) async {
    try {
      return await http.Response.fromStream(await _http.send(request()).timeout(timeout));
    } on TimeoutException {
      throw const NetworkFailure();
    } on SocketException {
      if (retry) return _fetch(request, retry: false);
      throw const NetworkFailure();
    } on http.ClientException {
      if (retry) return _fetch(request, retry: false);
      throw const NetworkFailure();
    }
  }
}
