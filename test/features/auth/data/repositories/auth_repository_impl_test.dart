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
    group('login', () {
      test(
        'calls dataSource.login and returns Right(AuthEntity) on success',
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
        'calls sharedPreferences.setBool when keepLoggedIn is true',
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
          when(
            () => mockDataSource.login(any(), any()),
          ).thenThrow(ServerFailure());

          final result = await repository.login(tUserEntity);

          expect(result, Left(ServerFailure()));
        },
      );
    });

    group('logout', () {
      test('calls sharedPreferences and dataSource.logout and returns Right(null)', () async {
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

      test('returns Left(ServerFailure) when logout fails', () async {
        when(() => mockDataSource.logout()).thenThrow(ServerFailure());

        final result = await repository.logout();

        expect(result, Left(ServerFailure()));
      });
    });

    group('checkAuthStatus', () {
      test(
        'returns Right(true) when sharedPreferences.getBool returns true',
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
        'returns Right(false) when getBool returns null or false',
        () async {
          when(
            () => mockSharedPreferences.getBool(any()),
          ).thenReturn(null);

          final result = await repository.checkAuthStatus();

          expect(result, const Right(false));
        },
      );

      test(
        'returns Right(false) on exception (does not block Splash)',
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
        'returns Left(ServerFailure) when register fails',
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
