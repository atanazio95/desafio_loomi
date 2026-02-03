import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:desafio_loomi_flutter/core/errors/failures.dart';
import 'package:desafio_loomi_flutter/features/user/domain/entities/user_entity.dart';
import 'package:desafio_loomi_flutter/features/user/domain/usecases/get_user_profile_usecase.dart';
import 'package:desafio_loomi_flutter/features/user/domain/usecases/update_user_profile_usecase.dart';
import 'package:desafio_loomi_flutter/features/user/presentation/bloc/user_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetUserProfileUseCase extends Mock implements GetUserProfileUseCase {}

class MockUpdateUserProfileUseCase extends Mock
    implements UpdateUserProfileUseCase {}

const tUser = UserEntity(
  id: 1,
  name: 'Test User',
  email: 'user@test.com',
  language: 'pt-BR',
  dateFormat: 'DD/MM/AA',
  timezone: 'America/Sao_Paulo',
  address: null,
);

void main() {
  late UserBloc bloc;
  late MockGetUserProfileUseCase mockGetUserProfileUseCase;
  late MockUpdateUserProfileUseCase mockUpdateUserProfileUseCase;

  setUpAll(() {
    registerFallbackValue(tUser);
  });

  setUp(() {
    mockGetUserProfileUseCase = MockGetUserProfileUseCase();
    mockUpdateUserProfileUseCase = MockUpdateUserProfileUseCase();
    bloc = UserBloc(
      getUserProfileUseCase: mockGetUserProfileUseCase,
      updateUserProfileUseCase: mockUpdateUserProfileUseCase,
    );
  });

  tearDown(() {
    bloc.close();
  });

  group('UserBloc', () {
    test('estado inicial é UserInitial', () {
      expect(bloc.state, equals(UserInitial()));
    });

    group('GetUserProfile', () {
      blocTest<UserBloc, UserState>(
        'emite [UserLoading, UserLoaded] quando getProfile tem sucesso',
        build: () {
          when(
            () => mockGetUserProfileUseCase(),
          ).thenAnswer((_) async => const Right(tUser));
          return bloc;
        },
        act: (b) => b.add(GetUserProfile()),
        expect: () => [UserLoading(), UserLoaded(tUser)],
        verify: (_) {
          verify(() => mockGetUserProfileUseCase()).called(1);
        },
      );

      blocTest<UserBloc, UserState>(
        'emite [UserLoading, UserError] quando getProfile falha',
        build: () {
          when(
            () => mockGetUserProfileUseCase(),
          ).thenAnswer((_) async => Left(ServerFailure()));
          return bloc;
        },
        act: (b) => b.add(GetUserProfile()),
        expect: () => [
          UserLoading(),
          const UserError('Erro ao carregar perfil'),
        ],
      );
    });

    group('UpdateUserProfile', () {
      blocTest<UserBloc, UserState>(
        'emite [UserLoading, UserUpdated] quando update tem sucesso',
        build: () {
          when(
            () => mockUpdateUserProfileUseCase(any()),
          ).thenAnswer((_) async => const Right(null));
          return bloc;
        },
        act: (b) => b.add(UpdateUserProfile(tUser)),
        expect: () => [UserLoading(), UserUpdated(tUser)],
        verify: (_) {
          verify(() => mockUpdateUserProfileUseCase(tUser)).called(1);
        },
      );

      blocTest<UserBloc, UserState>(
        'emite [UserLoading, UserError] quando update falha',
        build: () {
          when(
            () => mockUpdateUserProfileUseCase(any()),
          ).thenAnswer((_) async => Left(ServerFailure()));
          return bloc;
        },
        act: (b) => b.add(UpdateUserProfile(tUser)),
        expect: () => [
          UserLoading(),
          const UserError('Erro ao atualizar perfil'),
        ],
      );
    });
  });
}
