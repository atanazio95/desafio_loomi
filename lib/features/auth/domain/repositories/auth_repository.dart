import 'package:dartz/dartz.dart';
import 'package:desafio_loomi_flutter/core/errors/failures.dart';
import 'package:desafio_loomi_flutter/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, bool>> login(UserEntity user);
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, bool>> checkAuthStatus();
}
