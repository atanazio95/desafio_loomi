import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  // O "call" permite que usemos a classe como uma função: loginUseCase(user)
  Future<Either<Failure, bool>> call(UserEntity user) async {
    return await repository.login(user);
  }
}
