import 'package:flutter_app_template/core/error/failure.dart';
import 'package:flutter_app_template/core/error/result.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Result.fold', () {
    test('calls onSuccess for Success', () {
      const Result<int> result = Success(2);
      final out = result.fold((v) => 'ok $v', (f) => 'fail');
      expect(out, 'ok 2');
    });

    test('calls onFailure for ResultFailure', () {
      const Result<int> result = ResultFailure(NetworkFailure());
      final out = result.fold((v) => 'ok', (f) => f.message);
      expect(out, const NetworkFailure().message);
    });
  });

  group('Result.map', () {
    test('transforms the success value', () {
      const Result<int> result = Success(2);
      expect(result.map((v) => v * 10), const Success(20));
    });

    test('passes the same failure through', () {
      const failure = ServerFailure(statusCode: 500);
      const Result<int> result = ResultFailure(failure);
      final mapped = result.map((v) => '$v');
      expect(mapped, const ResultFailure<String>(failure));
    });
  });

  test('equal successes compare equal', () {
    expect(const Success(1), const Success(1));
    expect(const Success(1), isNot(const Success(2)));
  });

  test('failures with the same data compare equal', () {
    expect(
      const ServerFailure(statusCode: 404),
      const ServerFailure(statusCode: 404),
    );
    expect(
      const ServerFailure(statusCode: 404),
      isNot(const ServerFailure(statusCode: 500)),
    );
  });
}
