import 'package:dartz/dartz.dart';
import 'package:desafio_loomi_flutter/core/errors/failures.dart';
import 'package:desafio_loomi_flutter/features/user/domain/entities/user_entity.dart';
import 'package:desafio_loomi_flutter/features/user/domain/repositories/user_repository.dart';
import 'package:desafio_loomi_flutter/features/user/domain/usecases/get_user_profile_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  late GetUserProfileUseCase usecase;
  late MockUserRepository mockUserRepository;

  setUp(() {
    mockUserRepository = MockUserRepository();
    usecase = GetUserProfileUseCase(mockUserRepository);
  });

  const tUser = UserEntity(
    id: 1,
    name: 'Test User',
    email: 'user@test.com',
    language: 'pt-BR',
    dateFormat: 'DD/MM/AA',
    timezone: 'America/Sao_Paulo',
    address: null,
  );

  group('GetUserProfileUseCase', () {
    test(
      'returns Right(UserEntity) when getUserProfile succeeds',
      () async {
        when(
          () => mockUserRepository.getUserProfile(),
        ).thenAnswer((_) async => const Right(tUser));

        final result = await usecase();

        expect(result, const Right(tUser));
        verify(() => mockUserRepository.getUserProfile()).called(1);
      },
    );

    test(
      'returns Left(ServerFailure) when getUserProfile fails',
      () async {
        when(
          () => mockUserRepository.getUserProfile(),
        ).thenAnswer((_) async => Left(ServerFailure()));

        final result = await usecase();

        expect(result, Left(ServerFailure()));
        verify(() => mockUserRepository.getUserProfile()).called(1);
      },
    );
  });
}
