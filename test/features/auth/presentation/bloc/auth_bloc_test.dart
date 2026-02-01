// import 'package:bloc_test/bloc_test.dart';
// import 'package:dartz/dartz.dart';
// import 'package:desafio_loomi_flutter/core/errors/failures.dart';
// import 'package:desafio_loomi_flutter/features/auth/domain/entities/user_entity.dart';
// import 'package:desafio_loomi_flutter/features/auth/domain/repositories/auth_repository.dart';
// import 'package:desafio_loomi_flutter/features/auth/domain/usecases/check_auth_status_usecase.dart';
// import 'package:desafio_loomi_flutter/features/auth/domain/usecases/login_usecase.dart';
// import 'package:desafio_loomi_flutter/features/auth/presentation/bloc/auth_bloc.dart';
// import 'package:desafio_loomi_flutter/features/auth/presentation/bloc/auth_event.dart';
// import 'package:desafio_loomi_flutter/features/auth/presentation/bloc/auth_state.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mocktail/mocktail.dart';

// class MockLoginUseCase extends Mock implements LoginUseCase {}

// class MockAuthRepository extends Mock implements AuthRepository {}

// class MockCheckAuthStatusUseCase extends Mock
//     implements CheckAuthStatusUseCase {}

// void main() {
//   late AuthBloc bloc;
//   late MockLoginUseCase mockLoginUseCase;
//   late MockAuthRepository mockAuthRepository;
//   late MockCheckAuthStatusUseCase mockCheckAuthStatusUseCase;

//   const tLogin = "teste@loomi.com";
//   const tPassword = "123";
//   const tUserEntity = UserEntity(login: tLogin, password: tPassword);

//   setUp(() {
//     mockLoginUseCase = MockLoginUseCase();
//     mockAuthRepository = MockAuthRepository();
//     mockCheckAuthStatusUseCase = MockCheckAuthStatusUseCase();

//     bloc = AuthBloc(
//       loginUseCase: mockLoginUseCase,
//       authRepository: mockAuthRepository,
//       checkAuthStatusUseCase: mockCheckAuthStatusUseCase,
//     );

//     registerFallbackValue(tUserEntity);
//   });

//   tearDown(() {
//     bloc.close();
//   });

//   // GRUPO 1: LOGIN (Já fizemos)
//   group('AuthBloc - Login', () {
//     test('estado inicial é AuthInitial', () {
//       expect(bloc.state, equals(AuthInitial()));
//     });

//     blocTest<AuthBloc, AuthState>(
//       'deve emitir [AuthLoading, AuthAuthenticated] no login com sucesso',
//       build: () {
//         when(
//           () => mockLoginUseCase(any()),
//         ).thenAnswer((_) async => const Right(true));
//         return bloc;
//       },
//       act: (bloc) =>
//           bloc.add(const LoginSubmitted(username: tLogin, password: tPassword)),
//       expect: () => [AuthLoading(), AuthAuthenticated()],
//     );

//     blocTest<AuthBloc, AuthState>(
//       'deve emitir [AuthLoading, AuthError] no login com falha',
//       build: () {
//         when(
//           () => mockLoginUseCase(any()),
//         ).thenAnswer((_) async => Left(ServerFailure()));
//         return bloc;
//       },
//       act: (bloc) =>
//           bloc.add(const LoginSubmitted(username: tLogin, password: tPassword)),
//       expect: () => [
//         AuthLoading(),
//         const AuthError(
//           message: "Erro ao realizar login. Verifique suas credenciais.",
//         ),
//       ],
//     );
//   });

//   // GRUPO 2: SPLASH SCREEN (CheckStatus)
//   group('AuthBloc - CheckStatus (Splash)', () {
//     blocTest<AuthBloc, AuthState>(
//       'deve emitir [AuthLoading, AuthAuthenticated] se o token já existir (usuário logado)',
//       build: () {
//         // Simulamos que o UseCase disse: "Sim, tem usuário logado" (true)
//         when(() => mockCheckAuthStatusUseCase()).thenAnswer((_) async => true);
//         return bloc;
//       },
//       act: (bloc) => bloc.add(AuthCheckRequested()),
//       expect: () => [
//         AuthLoading(),
//         AuthAuthenticated(), // Vai direto pra Home
//       ],
//     );

//     blocTest<AuthBloc, AuthState>(
//       'deve emitir [AuthLoading, AuthUnauthenticated] se não houver token salvo',
//       build: () {
//         // Simulamos que o UseCase disse: "Não, ninguém logado" (false)
//         when(() => mockCheckAuthStatusUseCase()).thenAnswer((_) async => false);
//         return bloc;
//       },
//       act: (bloc) => bloc.add(AuthCheckRequested()),
//       expect: () => [
//         AuthLoading(),
//         AuthUnauthenticated(), // Vai pra tela de Login
//       ],
//     );
//   });

//   // GRUPO 3: LOGOUT
//   group('AuthBloc - Logout', () {
//     blocTest<AuthBloc, AuthState>(
//       'deve chamar o repository.logout e emitir [AuthUnauthenticated]',
//       build: () {
//         // Simulamos o logout retornando void (Future<void>)
//         when(
//           () => mockAuthRepository.logout(),
//         ).thenAnswer((_) async => Right(null));
//         return bloc;
//       },
//       act: (bloc) => bloc.add(LogoutRequested()),
//       expect: () => [
//         // No seu código original de logout você não emite Loading, vai direto
//         AuthUnauthenticated(),
//       ],
//       verify: (_) {
//         verify(() => mockAuthRepository.logout()).called(1);
//       },
//     );
//   });
// }
