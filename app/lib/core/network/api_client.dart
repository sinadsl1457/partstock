// 시세 API(Spring 서버) GET 호출. 저장소(MarketRepository)만 부른다.
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

  Future<Map<String, dynamic>> get(String path, Map<String, String> query) async {
    final uri = Uri.parse(_base + path).replace(queryParameters: query);
    final http.Response res;
    try {
      res = await _http.get(uri).timeout(timeout);
    } on TimeoutException {
      throw const NetworkFailure();
    } on SocketException {
      throw const NetworkFailure();
    } on http.ClientException {
      throw const NetworkFailure();
    }
    if (res.statusCode == 404) throw const NotFoundFailure();
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw ServerFailure(res.statusCode);
    }
    return jsonDecode(utf8.decode(res.bodyBytes)) as Map<String, dynamic>;
  }
}
