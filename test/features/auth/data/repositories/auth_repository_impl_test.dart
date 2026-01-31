import 'package:dartz/dartz.dart';
import 'package:desafio_loomi_flutter/core/errors/failures.dart';
import 'package:desafio_loomi_flutter/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:desafio_loomi_flutter/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:desafio_loomi_flutter/features/auth/domain/entities/user_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// 1. Mock do DataSource
class MockAuthRemoteDatasource extends Mock implements AuthRemoteDatasource {}

void main() {
  late AuthRepositoryImpl repository;
  late MockAuthRemoteDatasource mockDataSource;

  setUp(() {
    mockDataSource = MockAuthRemoteDatasource();
    repository = AuthRepositoryImpl(dataSource: mockDataSource);
  });

  const tLogin = 'jeorge@loomi.com';
  const tPassword = '123';
  const tUserEntity = UserEntity(login: tLogin, password: tPassword);

  group('AuthRepositoryImpl', () {
    // --- TESTES DE LOGIN ---
    group('login', () {
      test(
        'deve chamar o dataSource.login com strings e retornar Right(true) no sucesso',
        () async {
          // ARRANGE
          // Simulamos que o DataSource aceita as strings e retorna true
          when(
            () => mockDataSource.login(any(), any()),
          ).thenAnswer((_) async => true);

          // ACT
          final result = await repository.login(tUserEntity);

          // ASSERT
          expect(result, const Right(true));

          // VERIFICAÇÃO CRUCIAL:
          // Verificamos se ele "desmontou" a entidade e passou as strings certas
          verify(() => mockDataSource.login(tLogin, tPassword)).called(1);
        },
      );

      test(
        'deve retornar Left(ServerFailure) quando o dataSource falhar',
        () async {
          // ARRANGE
          when(
            () => mockDataSource.login(any(), any()),
          ).thenThrow(ServerFailure());

          // ACT
          final result = await repository.login(tUserEntity);

          // ASSERT
          expect(result, Left(ServerFailure()));
        },
      );
    });

    // --- TESTES DE LOGOUT ---
    group('logout', () {
      test('deve chamar dataSource.logout e retornar Right(null)', () async {
        // ARRANGE
        when(
          () => mockDataSource.logout(),
        ).thenAnswer((_) async {}); // Future<void>

        // ACT
        final result = await repository.logout();

        // ASSERT
        expect(result, const Right(null));
        verify(() => mockDataSource.logout()).called(1);
      });

      test('deve retornar Left(ServerFailure) se o logout falhar', () async {
        // ARRANGE
        when(() => mockDataSource.logout()).thenThrow(ServerFailure());

        // ACT
        final result = await repository.logout();

        // ASSERT
        expect(result, Left(ServerFailure()));
      });
    });

    // --- TESTES DE CHECK AUTH STATUS ---
    group('checkAuthStatus', () {
      test(
        'deve retornar Right(true) se o dataSource disser que está logado',
        () async {
          when(
            () => mockDataSource.checkAuthStatus(),
          ).thenAnswer((_) async => true);

          final result = await repository.checkAuthStatus();

          expect(result, const Right(true));
        },
      );

      test(
        'deve retornar Right(false) se ocorrer uma exceção (conforme sua lógica)',
        () async {
          // Na sua implementação, o catch retorna Right(false) em vez de Left(Failure)
          // Isso é útil para não travar a Splash Screen com tela de erro
          when(
            () => mockDataSource.checkAuthStatus(),
          ).thenThrow(Exception()); // Qualquer erro

          final result = await repository.checkAuthStatus();

          expect(result, const Right(false));
        },
      );
    });
  });
}
