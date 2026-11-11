import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_template/core/session/session_bloc.dart';
import 'package:flutter_app_template/core/theme/app_theme.dart';
import 'package:flutter_app_template/features/auth/application/form_status.dart';
import 'package:flutter_app_template/features/auth/application/sign_in/sign_in_bloc.dart';
import 'package:flutter_app_template/features/auth/domain/entities/user.dart';
import 'package:flutter_app_template/features/auth/presentation/auth_strings.dart';
import 'package:flutter_app_template/features/auth/presentation/pages/sign_in_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockSignInBloc extends MockBloc<SignInEvent, SignInState>
    implements SignInBloc {}

class _MockSessionBloc extends MockBloc<SessionEvent, SessionState>
    implements SessionBloc {}

void main() {
  late _MockSignInBloc bloc;
  late _MockSessionBloc session;
  var createAccountTaps = 0;

  setUpAll(() {
    registerFallbackValue(const SignInSubmitted());
    registerFallbackValue(const SessionChecked());
  });

  setUp(() {
    bloc = _MockSignInBloc();
    session = _MockSessionBloc();
    createAccountTaps = 0;
    when(() => session.state).thenReturn(const SessionState.unauthenticated());
  });

  Future<void> pump(WidgetTester tester, {bool dark = false}) =>
      tester.pumpWidget(
        MaterialApp(
          theme: dark ? AppTheme.dark() : AppTheme.light(),
          home: MultiBlocProvider(
            providers: [
              BlocProvider<SignInBloc>.value(value: bloc),
              BlocProvider<SessionBloc>.value(value: session),
            ],
            child: SignInPage(onCreateAccount: () => createAccountTaps++),
          ),
        ),
      );

  testWidgets('typing and tapping Entrar dispatches the form events', (
    tester,
  ) async {
    when(() => bloc.state).thenReturn(const SignInState());
    await pump(tester);
    await tester.enterText(find.byType(TextField).at(0), 'ana@ex.com');
    await tester.enterText(find.byType(TextField).at(1), '12345678');
    await tester.tap(find.text(AuthStrings.signIn));
    verify(() => bloc.add(const SignInEmailChanged('ana@ex.com'))).called(1);
    verify(() => bloc.add(const SignInPasswordChanged('12345678'))).called(1);
    verify(() => bloc.add(const SignInSubmitted())).called(1);
  });

  testWidgets('email and password fields show their hints', (tester) async {
    when(() => bloc.state).thenReturn(const SignInState());
    await pump(tester);
    expect(find.text(AuthStrings.emailHint), findsOneWidget);
    expect(find.text(AuthStrings.passwordHint), findsOneWidget);
  });

  testWidgets('while loading the button shows progress and ignores taps', (
    tester,
  ) async {
    when(() => bloc.state)
        .thenReturn(const SignInState(status: FormStatus.loading));
    await pump(tester, dark: true);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.tap(
      find.byType(CircularProgressIndicator),
      warnIfMissed: false,
    );
    verifyNever(() => bloc.add(const SignInSubmitted()));
  });

  testWidgets('success starts the session', (tester) async {
    const user = User(id: '1', name: 'Ana', email: 'ana@ex.com');
    when(() => bloc.state).thenReturn(const SignInState());
    whenListen(
      bloc,
      Stream.value(const SignInState(status: FormStatus.success, user: user)),
      initialState: const SignInState(),
    );
    await pump(tester);
    await tester.pump();
    verify(
      () => session.add(
        const SessionStarted(
          SessionUser(id: '1', name: 'Ana', email: 'ana@ex.com'),
        ),
      ),
    ).called(1);
  });

  testWidgets('failure shows the message in a snackbar', (tester) async {
    whenListen(
      bloc,
      Stream.value(
        const SignInState(
          status: FormStatus.failure,
          errorMessage: 'Sem conexão',
        ),
      ),
      initialState: const SignInState(),
    );
    await pump(tester);
    await tester.pump();
    expect(find.text('Sem conexão'), findsOneWidget);
  });

  testWidgets('field errors from the state are shown', (tester) async {
    when(() => bloc.state)
        .thenReturn(const SignInState(email: 'a', submitted: true));
    await pump(tester);
    expect(find.text('Informe um e-mail válido'), findsOneWidget);
  });

  testWidgets('Criar conta calls the navigation callback', (tester) async {
    when(() => bloc.state).thenReturn(const SignInState());
    await pump(tester);
    await tester.ensureVisible(find.text(AuthStrings.createAccount));
    await tester.tap(find.text(AuthStrings.createAccount));
    expect(createAccountTaps, 1);
  });

  testWidgets('Esqueci a senha explains it is not available', (tester) async {
    when(() => bloc.state).thenReturn(const SignInState());
    await pump(tester);
    await tester.tap(find.text(AuthStrings.forgotPassword));
    await tester.pump();
    expect(find.text(AuthStrings.forgotPasswordUnavailable), findsOneWidget);
  });
}
