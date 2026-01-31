import 'package:desafio_loomi_flutter/features/auth/domain/repositories/auth_repository.dart';

class CheckAuthStatusUseCase {
  final AuthRepository repository;

  CheckAuthStatusUseCase(this.repository);

  Future<bool> call() async {
    final result = await repository.checkAuthStatus();
    return result.fold((failure) => false, (isLoggedIn) => isLoggedIn);
  }
}
