import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:desafio_loomi_flutter/core/errors/failures.dart';
import 'package:desafio_loomi_flutter/features/auth/domain/entities/auth_entity.dart';
import 'package:desafio_loomi_flutter/features/auth/domain/repositories/auth_repository.dart';
import 'package:desafio_loomi_flutter/features/auth/domain/usecases/check_auth_status_usecase.dart';
import 'package:desafio_loomi_flutter/features/auth/domain/usecases/login_usecase.dart';
import 'package:desafio_loomi_flutter/features/auth/domain/usecases/register_usecase.dart';
import 'package:desafio_loomi_flutter/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:desafio_loomi_flutter/features/auth/presentation/bloc/auth_event.dart';
import 'package:desafio_loomi_flutter/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockLoginUseCase extends Mock implements LoginUseCase {}

class MockRegisterUseCase extends Mock implements RegisterUseCase {}

class MockAuthRepository extends Mock implements AuthRepository {}

class MockCheckAuthStatusUseCase extends Mock implements CheckAuthStatusUseCase {}

void main() {
  late AuthBloc bloc;
  late MockLoginUseCase mockLoginUseCase;
  late MockRegisterUseCase mockRegisterUseCase;
  late MockAuthRepository mockAuthRepository;
  late MockCheckAuthStatusUseCase mockCheckAuthStatusUseCase;

  const tLogin = 'teste@loomi.com';
  const tPassword = '123';
  const tAuthEntity = AuthEntity(login: tLogin, password: tPassword);

  setUp(() {
    mockLoginUseCase = MockLoginUseCase();
    mockRegisterUseCase = MockRegisterUseCase();
    mockAuthRepository = MockAuthRepository();
    mockCheckAuthStatusUseCase = MockCheckAuthStatusUseCase();

    bloc = AuthBloc(
      loginUseCase: mockLoginUseCase,
      registerUseCase: mockRegisterUseCase,
      authRepository: mockAuthRepository,
      checkAuthStatusUseCase: mockCheckAuthStatusUseCase,
    );

    registerFallbackValue(tAuthEntity);
  });

  tearDown(() {
    bloc.close();
  });

  group('AuthBloc', () {
    test('estado inicial é AuthInitial', () {
      expect(bloc.state, equals(AuthInitial()));
    });

    group('Login', () {
      blocTest<AuthBloc, AuthState>(
        'emite [AuthLoading, AuthAuthenticated] no login com sucesso',
        build: () {
          when(
            () => mockLoginUseCase(any(), keepLoggedIn: any(named: 'keepLoggedIn')),
          ).thenAnswer((_) async => const Right(tAuthEntity));
          return bloc;
        },
        act: (b) => b.add(LoginSubmitted(
          username: tLogin,
          password: tPassword,
        )),
        expect: () => [AuthLoading(), AuthAuthenticated()],
      );

      blocTest<AuthBloc, AuthState>(
        'emite [AuthLoading, AuthError] no login com falha',
        build: () {
          when(
            () => mockLoginUseCase(any(), keepLoggedIn: any(named: 'keepLoggedIn')),
          ).thenAnswer((_) async => Left(ServerFailure()));
          return bloc;
        },
        act: (b) => b.add(LoginSubmitted(
          username: tLogin,
          password: tPassword,
        )),
        expect: () => [
          AuthLoading(),
          const AuthError(
            message: 'Erro ao realizar login. Verifique suas credenciais.',
          ),
        ],
      );
    });

    group('Register', () {
      blocTest<AuthBloc, AuthState>(
        'emite [AuthLoading, AuthAuthenticated] no cadastro com sucesso',
        build: () {
          when(
            () => mockRegisterUseCase(any()),
          ).thenAnswer((_) async => const Right(tAuthEntity));
          return bloc;
        },
        act: (b) => b.add(RegisterSubmitted(
          username: tLogin,
          password: tPassword,
        )),
        expect: () => [AuthLoading(), AuthAuthenticated()],
      );

      blocTest<AuthBloc, AuthState>(
        'emite [AuthLoading, AuthError] no cadastro com falha',
        build: () {
          when(
            () => mockRegisterUseCase(any()),
          ).thenAnswer((_) async => Left(ServerFailure()));
          return bloc;
        },
        act: (b) => b.add(RegisterSubmitted(
          username: tLogin,
          password: tPassword,
        )),
        expect: () => [
          AuthLoading(),
          const AuthError(message: 'Erro ao simular cadastro'),
        ],
      );
    });

    group('CheckAuthStatus (Splash)', () {
      blocTest<AuthBloc, AuthState>(
        'emite [AuthLoading, AuthAuthenticated] quando já logado',
        build: () {
          when(() => mockCheckAuthStatusUseCase()).thenAnswer((_) async => true);
          return bloc;
        },
        act: (b) => b.add(AuthCheckRequested()),
        expect: () => [AuthLoading(), AuthAuthenticated()],
      );

      blocTest<AuthBloc, AuthState>(
        'emite [AuthLoading, AuthUnauthenticated] quando não logado',
        build: () {
          when(() => mockCheckAuthStatusUseCase()).thenAnswer((_) async => false);
          return bloc;
        },
        act: (b) => b.add(AuthCheckRequested()),
        expect: () => [AuthLoading(), AuthUnauthenticated()],
      );
    });

    group('Logout', () {
      blocTest<AuthBloc, AuthState>(
        'chama authRepository.logout e emite AuthUnauthenticated',
        build: () {
          when(
            () => mockAuthRepository.logout(),
          ).thenAnswer((_) async => const Right(null));
          return bloc;
        },
        act: (b) => b.add(LogoutRequested()),
        expect: () => [AuthUnauthenticated()],
        verify: (_) {
          verify(() => mockAuthRepository.logout()).called(1);
        },
      );
    });
  });
}
