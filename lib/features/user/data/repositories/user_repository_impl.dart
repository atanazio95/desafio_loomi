import 'package:dartz/dartz.dart';
import 'package:desafio_loomi_flutter/core/errors/failures.dart';
import 'package:desafio_loomi_flutter/features/user/data/datasources/user_datasources.dart';
import 'package:desafio_loomi_flutter/features/user/data/models/user_model.dart';
import 'package:desafio_loomi_flutter/features/user/domain/entities/user_entity.dart';
import 'package:desafio_loomi_flutter/features/user/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserDataSource dataSource;

  UserRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, UserEntity>> getUserProfile() async {
    try {
      final result = await dataSource.getUserProfile();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> updateUserProfile(UserEntity user) async {
    try {
      // Converte a Entity (Domínio) para Model (Dados)
      // Lembre-se de implementar o toModel() ou criar o objeto manualmente aqui
      final userModel = UserModel(
        id: user.id,
        name: user.name,
        email: user.email,
        language: user.language,
        dateFormat: user.dateFormat,
        timezone: user.timezone,
        address: user
            .address, // O UserModel deve aceitar AddressEntity ou ter conversão
      );

      await dataSource.updateUserProfile(userModel);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
