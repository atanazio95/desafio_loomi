import 'package:dartz/dartz.dart';
import 'package:desafio_loomi_flutter/core/errors/failures.dart';
import 'package:desafio_loomi_flutter/features/auth/domain/entities/user_entity.dart';
import 'package:desafio_loomi_flutter/features/auth/domain/repositories/auth_repository.dart';
import 'package:desafio_loomi_flutter/features/auth/domain/usecases/login_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late LoginUseCase usecase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    usecase = LoginUseCase(mockAuthRepository);
  });

  const tUserEntity = UserEntity(login: 'jeorge@loomi.com', password: '123');

  test(
    'deve retornar Right(true) quando o login for realizado com sucesso',
    () async {
      // ARRANGE
      // Configura o mock para retornar true (sucesso)
      when(
        () => mockAuthRepository.login(tUserEntity),
      ).thenAnswer((_) async => const Right(true));

      // ACT
      final result = await usecase(tUserEntity);

      // ASSERT
      // Esperamos um booleano true dentro do Right
      expect(result, const Right(true));

      verify(() => mockAuthRepository.login(tUserEntity)).called(1);
    },
  );

  test('deve retornar Left(ServerFailure) quando o login falhar', () async {
    // ARRANGE
    when(
      () => mockAuthRepository.login(tUserEntity),
    ).thenAnswer((_) async => Left(ServerFailure()));

    // ACT
    final result = await usecase(tUserEntity);

    // ASSERT
    expect(result, Left(ServerFailure()));
    verify(() => mockAuthRepository.login(tUserEntity)).called(1);
  });
}
