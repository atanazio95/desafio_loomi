import 'package:dartz/dartz.dart';

import 'package:desafio_loomi_flutter/core/errors/failures.dart';
import 'package:desafio_loomi_flutter/features/user/domain/entities/user_entity.dart';

abstract class UserRepository {
  Future<Either<Failure, UserEntity>> getUserProfile();
  Future<Either<Failure, void>> updateUserProfile(UserEntity user);
}
