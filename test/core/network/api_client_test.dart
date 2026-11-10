import 'dart:convert';

import 'package:flutter_app_template/core/config/env_config.dart';
import 'package:flutter_app_template/core/error/app_exception.dart';
import 'package:flutter_app_template/core/error/failure.dart';
import 'package:flutter_app_template/core/error/failure_mapper.dart';
import 'package:flutter_app_template/core/network/api_client.dart';
import 'package:flutter_app_template/core/storage/secure/secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

class _MemorySecureStorage implements SecureStorage {
  _MemorySecureStorage([Map<String, String>? initial]) : _data = {...?initial};
  final Map<String, String> _data;

  @override
  Future<String?> read(String key) async => _data[key];
  @override
  Future<void> write(String key, String value) async => _data[key] = value;
  @override
  Future<void> delete(String key) async => _data.remove(key);
}

const _config = EnvConfig(apiBaseUrl: 'https://api.test', sentryDsn: '');

ApiClient _client(
  Future<http.Response> Function(http.Request) handler, {
  String? token,
}) => ApiClient(
  client: MockClient(handler),
  config: _config,
  storage: _MemorySecureStorage({'auth_token': ?token}),
);

void main() {
  test('sends the bearer token when one is stored', () async {
    late http.Request sent;
    await _client((r) async {
      sent = r;
      return http.Response('{}', 200);
    }, token: 'abc').get('/me');
    expect(sent.headers['Authorization'], 'Bearer abc');
    expect(sent.url.toString(), 'https://api.test/me');
  });

  test('omits Authorization without a token', () async {
    late http.Request sent;
    await _client((r) async {
      sent = r;
      return http.Response('', 204);
    }).get('/ping');
    expect(sent.headers.containsKey('Authorization'), isFalse);
  });

  test('decodes a 2xx JSON body and treats an empty body as {}', () async {
    final body = await _client(
      (_) async => http.Response(jsonEncode({'id': 1}), 200),
    ).post('/items', body: {'a': 1});
    expect(body, {'id': 1});
    final empty = await _client((_) async => http.Response('', 204)).get('/x');
    expect(empty, isEmpty);
  });

  test('401 throws UnauthorizedException', () {
    expect(
      _client((_) async => http.Response('', 401)).get('/x'),
      throwsA(isA<UnauthorizedException>()),
    );
  });

  test('500 throws ServerException with the status code', () {
    expect(
      _client((_) async => http.Response('', 500)).get('/x'),
      throwsA(
        isA<ServerException>().having((e) => e.statusCode, 'statusCode', 500),
      ),
    );
  });

  test('a transport error throws NetworkException', () {
    expect(
      _client((_) async => throw http.ClientException('down')).get('/x'),
      throwsA(isA<NetworkException>()),
    );
  });

  group('mapExceptionToFailure', () {
    test('maps each AppException to its Failure', () {
      expect(
        mapExceptionToFailure(const NetworkException('x')),
        isA<NetworkFailure>(),
      );
      expect(
        mapExceptionToFailure(const UnauthorizedException('x')),
        isA<UnauthorizedFailure>(),
      );
      expect(
        mapExceptionToFailure(const ServerException('x', statusCode: 503)),
        const ServerFailure(statusCode: 503),
      );
      expect(
        mapExceptionToFailure(const StorageException('x')),
        isA<StorageFailure>(),
      );
    });

    test('anything else becomes UnexpectedFailure', () {
      expect(mapExceptionToFailure(StateError('x')), isA<UnexpectedFailure>());
    });
  });
}
