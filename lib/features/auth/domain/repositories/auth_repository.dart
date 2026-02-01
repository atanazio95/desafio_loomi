import 'package:dartz/dartz.dart';
import 'package:desafio_loomi_flutter/core/errors/failures.dart';
import 'package:desafio_loomi_flutter/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> login(
    UserEntity user, {
    bool keepLoggedIn,
  });
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, bool>> checkAuthStatus();
}
