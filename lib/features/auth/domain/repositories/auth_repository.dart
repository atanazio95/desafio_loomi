import 'package:dartz/dartz.dart';
import 'package:desafio_loomi_flutter/core/errors/failures.dart';
import 'package:desafio_loomi_flutter/features/auth/domain/entities/auth_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthEntity>> login(
    AuthEntity user, {
    bool keepLoggedIn,
  });
  Future<Either<Failure, AuthEntity>> register(AuthEntity user);
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, bool>> checkAuthStatus();
}
