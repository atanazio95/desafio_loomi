import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:desafio_loomi_flutter/core/errors/failures.dart';
import 'package:desafio_loomi_flutter/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:desafio_loomi_flutter/features/auth/domain/entities/auth_entity.dart';
import 'package:desafio_loomi_flutter/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource dataSource;
  final SharedPreferences sharedPreferences;

  AuthRepositoryImpl({
    required this.dataSource,
    required this.sharedPreferences,
  });

  @override
  Future<Either<Failure, AuthEntity>> login(
    AuthEntity user, {
    bool keepLoggedIn = false,
  }) async {
    try {
      await dataSource.login(user.login, user.password);

      if (keepLoggedIn) {
        await sharedPreferences.setBool('is_logged_in', true);
      }

      return Right(user);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, AuthEntity>> register(AuthEntity user) async {
    try {
      final userModel = await dataSource.register(user.login, user.password);
      return Right(userModel);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await sharedPreferences.setBool('is_logged_in', false);
      await dataSource.logout();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> checkAuthStatus() async {
    try {
      final isLoggedIn = sharedPreferences.getBool('is_logged_in') ?? false;
      return Right(isLoggedIn);
    } catch (e) {
      return const Right(false);
    }
  }
}
