import 'package:bloc_test/bloc_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_app_template/core/session/session_bloc.dart';
import 'package:flutter_app_template/core/theme/app_theme.dart';
import 'package:flutter_app_template/features/auth/application/sign_up/sign_up_bloc.dart';
import 'package:flutter_app_template/features/auth/presentation/auth_strings.dart';
import 'package:flutter_app_template/features/auth/presentation/pages/sign_up_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockSignUpBloc extends MockBloc<SignUpEvent, SignUpState>
    implements SignUpBloc {}

class _MockSessionBloc extends MockBloc<SessionEvent, SessionState>
    implements SessionBloc {}

void main() {
  late _MockSignUpBloc bloc;
  late _MockSessionBloc session;

  setUpAll(() => registerFallbackValue(const SignUpSubmitted()));

  setUp(() {
    bloc = _MockSignUpBloc();
    session = _MockSessionBloc();
    when(() => session.state).thenReturn(const SessionState.unauthenticated());
  });

  Future<void> pump(WidgetTester tester, {VoidCallback? onSignIn}) =>
      tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: MultiBlocProvider(
            providers: [
              BlocProvider<SignUpBloc>.value(value: bloc),
              BlocProvider<SessionBloc>.value(value: session),
            ],
            child: SignUpPage(onSignIn: onSignIn ?? () {}),
          ),
        ),
      );

  testWidgets('mismatched passwords show the error', (tester) async {
    when(() => bloc.state).thenReturn(
      const SignUpState(
        password: '12345678',
        confirmPassword: 'x',
        submitted: true,
      ),
    );
    await pump(tester);
    expect(find.text('As senhas não conferem'), findsOneWidget);
  });

  testWidgets('the terms checkbox and submit dispatch events', (tester) async {
    when(() => bloc.state).thenReturn(const SignUpState());
    await pump(tester);
    await tester.ensureVisible(find.text(AuthStrings.acceptTerms));
    await tester.tap(find.text(AuthStrings.acceptTerms));
    verify(() => bloc.add(const SignUpTermsChanged(accepted: true))).called(1);
    await tester.ensureVisible(find.text(AuthStrings.createAccount).last);
    await tester.tap(find.text(AuthStrings.createAccount).last);
    verify(() => bloc.add(const SignUpSubmitted())).called(1);
  });

  testWidgets('Entrar goes back to sign in', (tester) async {
    var taps = 0;
    when(() => bloc.state).thenReturn(const SignUpState());
    await pump(tester, onSignIn: () => taps++);
    await tester.ensureVisible(find.text(AuthStrings.signIn));
    await tester.tap(find.text(AuthStrings.signIn));
    expect(taps, 1);
  });
}
