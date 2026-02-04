import 'package:dartz/dartz.dart';
import 'package:desafio_loomi_flutter/core/errors/failures.dart';
import 'package:desafio_loomi_flutter/features/auth/domain/repositories/auth_repository.dart';
import 'package:desafio_loomi_flutter/features/auth/domain/usecases/check_auth_status_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late CheckAuthStatusUseCase usecase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    usecase = CheckAuthStatusUseCase(mockAuthRepository);
  });

  group('CheckAuthStatusUseCase', () {
    test('returns true when checkAuthStatus returns Right(true)', () async {
      when(
        () => mockAuthRepository.checkAuthStatus(),
      ).thenAnswer((_) async => const Right(true));

      final result = await usecase();

      expect(result, true);
      verify(() => mockAuthRepository.checkAuthStatus()).called(1);
    });

    test('deve retornar false quando checkAuthStatus retorna Right(false)', () async {
      when(
        () => mockAuthRepository.checkAuthStatus(),
      ).thenAnswer((_) async => const Right(false));

      final result = await usecase();

      expect(result, false);
    });

    test('returns false when checkAuthStatus returns Left(Failure)', () async {
      when(
        () => mockAuthRepository.checkAuthStatus(),
      ).thenAnswer((_) async => Left(ServerFailure()));

      final result = await usecase();

      expect(result, false);
    });
  });
}
