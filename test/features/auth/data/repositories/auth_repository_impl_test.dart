import 'package:dartz/dartz.dart';
import 'package:desafio_loomi_flutter/core/errors/failures.dart';
import 'package:desafio_loomi_flutter/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:desafio_loomi_flutter/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:desafio_loomi_flutter/features/auth/data/models/auth_model.dart';
import 'package:desafio_loomi_flutter/features/auth/domain/entities/auth_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockAuthRemoteDatasource extends Mock implements AuthRemoteDatasource {}

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late AuthRepositoryImpl repository;
  late MockAuthRemoteDatasource mockDataSource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockDataSource = MockAuthRemoteDatasource();
    mockSharedPreferences = MockSharedPreferences();
    repository = AuthRepositoryImpl(
      dataSource: mockDataSource,
      sharedPreferences: mockSharedPreferences,
    );
  });

  const tLogin = 'jeorge@loomi.com';
  const tPassword = '123';
  const tUserEntity = AuthEntity(login: tLogin, password: tPassword);

  group('AuthRepositoryImpl', () {
    // --- TESTES DE LOGIN ---
    group('login', () {
      test(
        'deve chamar o dataSource.login com strings e retornar Right(AuthEntity) no sucesso',
        () async {
          when(
            () => mockDataSource.login(any(), any()),
          ).thenAnswer((_) async => true);

          final result = await repository.login(tUserEntity);

          expect(result, const Right(tUserEntity));
          verify(() => mockDataSource.login(tLogin, tPassword)).called(1);
        },
      );

      test(
        'deve chamar sharedPreferences.setBool quando keepLoggedIn for true',
        () async {
          when(
            () => mockDataSource.login(any(), any()),
          ).thenAnswer((_) async => true);
          when(
            () => mockSharedPreferences.setBool(any(), any()),
          ).thenAnswer((_) async => true);

          await repository.login(tUserEntity, keepLoggedIn: true);

          verify(() => mockSharedPreferences.setBool('is_logged_in', true))
              .called(1);
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
      test('deve chamar sharedPreferences e dataSource.logout e retornar Right(null)', () async {
        when(
          () => mockSharedPreferences.setBool(any(), any()),
        ).thenAnswer((_) async => true);
        when(
          () => mockDataSource.logout(),
        ).thenAnswer((_) async {});

        final result = await repository.logout();

        expect(result, const Right(null));
        verify(() => mockSharedPreferences.setBool('is_logged_in', false)).called(1);
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
        'deve retornar Right(true) quando sharedPreferences.getBool retorna true',
        () async {
          when(
            () => mockSharedPreferences.getBool(any()),
          ).thenReturn(true);

          final result = await repository.checkAuthStatus();

          expect(result, const Right(true));
          verify(() => mockSharedPreferences.getBool('is_logged_in')).called(1);
        },
      );

      test(
        'deve retornar Right(false) quando getBool retorna null ou false',
        () async {
          when(
            () => mockSharedPreferences.getBool(any()),
          ).thenReturn(null);

          final result = await repository.checkAuthStatus();

          expect(result, const Right(false));
        },
      );

      test(
        'deve retornar Right(false) em exceção (não travar Splash)',
        () async {
          when(
            () => mockSharedPreferences.getBool(any()),
          ).thenThrow(Exception());

          final result = await repository.checkAuthStatus();

          expect(result, const Right(false));
        },
      );
    });

    // --- TESTES DE REGISTER ---
    group('register', () {
      test(
        'deve chamar dataSource.register e retornar Right(AuthEntity) no sucesso',
        () async {
          const authModel = AuthModel(login: tLogin, password: tPassword);
          when(
            () => mockDataSource.register(any(), any()),
          ).thenAnswer((_) async => authModel);

          final result = await repository.register(tUserEntity);

          expect(result.getOrElse(() => throw Exception()), authModel);
          verify(() => mockDataSource.register(tLogin, tPassword)).called(1);
        },
      );

      test(
        'deve retornar Left(ServerFailure) quando register falhar',
        () async {
          when(
            () => mockDataSource.register(any(), any()),
          ).thenThrow(ServerFailure());

          final result = await repository.register(tUserEntity);

          expect(result, Left(ServerFailure()));
        },
      );
    });
  });
}
