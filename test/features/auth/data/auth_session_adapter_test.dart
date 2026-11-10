import 'package:flutter_app_template/core/logging/app_logger.dart';
import 'package:flutter_app_template/core/session/session_port.dart';
import 'package:flutter_app_template/features/auth/data/auth_session_adapter.dart';
import 'package:flutter_app_template/features/auth/data/fake_auth_repository.dart';
import 'package:flutter_app_template/features/auth/domain/usecases/get_current_session.dart';
import 'package:flutter_app_template/features/auth/domain/usecases/sign_out.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/memory_secure_storage.dart';

class _MockLogger extends Mock implements AppLogger {}

void main() {
  test('current maps the stored user and end signs out', () async {
    final repo = FakeAuthRepository(
      MemorySecureStorage(),
      delay: Duration.zero,
    );
    final adapter = AuthSessionAdapter(
      GetCurrentSession(repo, _MockLogger()),
      SignOut(repo),
    );
    expect(await adapter.current(), isNull);
    final user = await repo.signIn(email: 'ana@ex.com', password: '12345678');
    expect(
      await adapter.current(),
      SessionUser(id: user.id, name: user.name, email: user.email),
    );
    await adapter.end();
    expect(await adapter.current(), isNull);
  });
}
