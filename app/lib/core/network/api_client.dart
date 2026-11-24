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
    final req = http.Request(method, uri)..headers.addAll(headers ?? const {});
    if (body != null) {
      req.headers['Content-Type'] = 'application/json';
      req.body = jsonEncode(body);
    }
    final http.Response res;
    try {
      res = await http.Response.fromStream(await _http.send(req).timeout(timeout));
    } on TimeoutException {
      throw const NetworkFailure();
    } on SocketException {
      throw const NetworkFailure();
    } on http.ClientException {
      throw const NetworkFailure();
    }
    if (res.statusCode == 404) throw const NotFoundFailure();
    if (res.statusCode < 200 || res.statusCode >= 300) throw ServerFailure(res.statusCode);
    if (res.bodyBytes.isEmpty) return null;
    return jsonDecode(utf8.decode(res.bodyBytes));
  }
}
