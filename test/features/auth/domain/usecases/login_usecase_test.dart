import 'package:dartz/dartz.dart';
import 'package:desafio_loomi_flutter/core/errors/failures.dart';
import 'package:desafio_loomi_flutter/features/auth/domain/entities/auth_entity.dart';
import 'package:desafio_loomi_flutter/features/auth/domain/repositories/auth_repository.dart';
import 'package:desafio_loomi_flutter/features/auth/domain/usecases/login_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late LoginUseCase usecase;
  late MockAuthRepository mockAuthRepository;

  const tAuthEntity = AuthEntity(login: 'jeorge@loomi.com', password: '123');

  setUpAll(() {
    registerFallbackValue(tAuthEntity);
  });

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    usecase = LoginUseCase(mockAuthRepository);
  });

  group('LoginUseCase', () {
    test(
      'returns Right(AuthEntity) when login succeeds',
      () async {
        when(
          () => mockAuthRepository.login(any(), keepLoggedIn: any(named: 'keepLoggedIn')),
        ).thenAnswer((_) async => const Right(tAuthEntity));

        final result = await usecase(tAuthEntity);

        expect(result, const Right(tAuthEntity));
        verify(
          () => mockAuthRepository.login(tAuthEntity, keepLoggedIn: false),
        ).called(1);
      },
    );

    test(
      'forwards keepLoggedIn true when provided',
      () async {
        when(
          () => mockAuthRepository.login(any(), keepLoggedIn: any(named: 'keepLoggedIn')),
        ).thenAnswer((_) async => const Right(tAuthEntity));

        await usecase(tAuthEntity, keepLoggedIn: true);

        verify(
          () => mockAuthRepository.login(tAuthEntity, keepLoggedIn: true),
        ).called(1);
      },
    );

    test('returns Left(ServerFailure) when login fails', () async {
      when(
        () => mockAuthRepository.login(any(), keepLoggedIn: any(named: 'keepLoggedIn')),
      ).thenAnswer((_) async => Left(ServerFailure()));

      final result = await usecase(tAuthEntity);

      expect(result, Left(ServerFailure()));
      verify(
        () => mockAuthRepository.login(tAuthEntity, keepLoggedIn: false),
      ).called(1);
    });
  });
}
