import 'package:dartz/dartz.dart';
import 'package:desafio_loomi_flutter/core/errors/failures.dart';
import 'package:desafio_loomi_flutter/features/auth/domain/entities/auth_entity.dart';
import 'package:desafio_loomi_flutter/features/auth/domain/repositories/auth_repository.dart';
import 'package:desafio_loomi_flutter/features/auth/domain/usecases/register_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late RegisterUseCase usecase;
  late MockAuthRepository mockAuthRepository;

  const tAuthEntity = AuthEntity(login: 'user@test.com', password: '123');

  setUpAll(() {
    registerFallbackValue(tAuthEntity);
  });

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    usecase = RegisterUseCase(mockAuthRepository);
  });

  group('RegisterUseCase', () {
    test(
      'returns Right(AuthEntity) when register succeeds',
      () async {
        when(
          () => mockAuthRepository.register(any()),
        ).thenAnswer((_) async => const Right(tAuthEntity));

        final result = await usecase(tAuthEntity);

        expect(result, const Right(tAuthEntity));
        verify(() => mockAuthRepository.register(tAuthEntity)).called(1);
      },
    );

    test('returns Left(ServerFailure) when register fails', () async {
      when(
        () => mockAuthRepository.register(any()),
      ).thenAnswer((_) async => Left(ServerFailure()));

      final result = await usecase(tAuthEntity);

      expect(result, Left(ServerFailure()));
      verify(() => mockAuthRepository.register(tAuthEntity)).called(1);
    });
  });
}
