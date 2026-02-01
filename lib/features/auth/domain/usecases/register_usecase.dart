import 'package:dartz/dartz.dart';
import 'package:desafio_loomi_flutter/core/errors/failures.dart';
import 'package:desafio_loomi_flutter/features/auth/domain/entities/user_entity.dart';
import 'package:desafio_loomi_flutter/features/auth/domain/repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;
  RegisterUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call(UserEntity user) async {
    return await repository.register(user);
  }
}
