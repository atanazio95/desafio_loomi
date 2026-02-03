import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/auth_entity.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<Either<Failure, AuthEntity>> call(
    AuthEntity user, {
    bool keepLoggedIn = false,
  }) async {
    return await repository.login(user, keepLoggedIn: keepLoggedIn);
  }
}
