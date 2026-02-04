import 'package:dartz/dartz.dart';
import 'package:desafio_loomi_flutter/core/errors/failures.dart';
import 'package:desafio_loomi_flutter/features/user/domain/entities/user_entity.dart';
import 'package:desafio_loomi_flutter/features/user/domain/repositories/user_repository.dart';
import 'package:desafio_loomi_flutter/features/user/domain/usecases/update_user_profile_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  late UpdateUserProfileUseCase usecase;
  late MockUserRepository mockUserRepository;

  const tUser = UserEntity(
    id: 1,
    name: 'Test User',
    email: 'user@test.com',
    language: 'pt-BR',
    dateFormat: 'DD/MM/AA',
    timezone: 'America/Sao_Paulo',
    address: null,
  );

  setUpAll(() {
    registerFallbackValue(tUser);
  });

  setUp(() {
    mockUserRepository = MockUserRepository();
    usecase = UpdateUserProfileUseCase(mockUserRepository);
  });

  group('UpdateUserProfileUseCase', () {
    test(
      'returns Right(null) when updateUserProfile succeeds',
      () async {
        when(
          () => mockUserRepository.updateUserProfile(any()),
        ).thenAnswer((_) async => const Right(null));

        final result = await usecase(tUser);

        expect(result, const Right(null));
        verify(() => mockUserRepository.updateUserProfile(tUser)).called(1);
      },
    );

    test(
      'returns Left(ServerFailure) when updateUserProfile fails',
      () async {
        when(
          () => mockUserRepository.updateUserProfile(any()),
        ).thenAnswer((_) async => Left(ServerFailure()));

        final result = await usecase(tUser);

        expect(result, Left(ServerFailure()));
        verify(() => mockUserRepository.updateUserProfile(tUser)).called(1);
      },
    );
  });
}
