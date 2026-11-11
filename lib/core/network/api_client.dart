import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../config/env_config.dart';
import '../constants/keys/storage_keys.dart';
import '../error/app_exception.dart';
import '../storage/secure/secure_storage.dart';

/// Thin JSON client over `package:http`.
///
/// Resolves paths against [EnvConfig.apiBaseUrl], attaches the stored bearer
/// token, and converts every failure into an [AppException]:
/// 401 → [UnauthorizedException], other non-2xx → [ServerException],
/// transport errors and timeouts → [NetworkException].
class ApiClient {
  // Private named parameters (Dart 3.13): callers still pass `client:`,
  // `config:` and `storage:`.
  ApiClient({
    required this._client,
    required this._config,
    required this._storage,
    this.timeout = const Duration(seconds: 30),
  });

  final http.Client _client;
  final EnvConfig _config;
  final SecureStorage _storage;
  final Duration timeout;

  Future<Map<String, dynamic>> get(String path, {Map<String, String>? query}) =>
      _send('GET', path, query: query);

  Future<Map<String, dynamic>> post(String path, {Object? body}) =>
      _send('POST', path, body: body);

  Future<Map<String, dynamic>> _send(
    String method,
    String path, {
    Map<String, String>? query,
    Object? body,
  }) async {
    final uri = Uri.parse('${_config.apiBaseUrl}$path')
        .replace(queryParameters: query);
    final request = http.Request(method, uri)
      ..headers['Content-Type'] = 'application/json'
      ..headers['Accept'] = 'application/json';
    final token = await _storage.read(StorageKeys.authToken);
    if (token != null && token.isNotEmpty) {
      request.headers['Authorization'] = 'Bearer $token';
    }
    if (body != null) request.body = jsonEncode(body);

    final http.Response response;
    try {
      response = await http.Response.fromStream(
        await _client.send(request).timeout(timeout),
      );
    } on TimeoutException catch (e, s) {
      throw NetworkException('timeout', cause: e, stackTrace: s);
    } on SocketException catch (e, s) {
      throw NetworkException('socket', cause: e, stackTrace: s);
    } on http.ClientException catch (e, s) {
      throw NetworkException('client', cause: e, stackTrace: s);
    }

    final status = response.statusCode;
    if (status == 401) throw const UnauthorizedException('unauthorized');
    if (status < 200 || status >= 300) {
      throw ServerException('http $status', statusCode: status);
    }
    if (response.body.isEmpty) return <String, dynamic>{};
    final decoded = jsonDecode(response.body);
    if (decoded is Map<String, dynamic>) return decoded;
    return <String, dynamic>{'data': decoded};
  }
}
