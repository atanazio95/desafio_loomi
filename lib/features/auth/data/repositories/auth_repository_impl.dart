import 'package:dartz/dartz.dart';
import 'package:desafio_loomi_flutter/core/errors/failures.dart';
import 'package:desafio_loomi_flutter/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:desafio_loomi_flutter/features/auth/domain/entities/user_entity.dart';
import 'package:desafio_loomi_flutter/features/auth/domain/repositories/auth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource dataSource;
  AuthRepositoryImpl({required this.dataSource});

  @override
  // CORREÇÃO: O tipo de retorno deve ser UserEntity, não bool
  Future<Either<Failure, UserEntity>> login(
    UserEntity user, {
    bool keepLoggedIn = false,
  }) async {
    try {
      // 1. O DataSource faz o login (verifique se ele retorna UserModel ou UserEntity)
      final result = await dataSource.login(user.login, user.password);

      // Se o login foi bem sucedido (assumindo que o dataSource lança erro se falhar)
      if (keepLoggedIn) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('is_logged_in', true);
      }

      // 2. CORREÇÃO: Retornamos a entidade do usuário
      // Se o 'result' for um UserModel, use: return Right(result.toEntity());
      // Se o 'result' já for bool (apenas sucesso), use: return Right(user);
      return Right(user);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, UserEntity>> register(UserEntity user) async {
    try {
      // Chamada ao DataSource (API)
      final userModel = await dataSource.register(user.login, user.password);

      // Opcional: Se o cadastro já logar o usuário automaticamente,
      // você pode salvar a flag no SharedPreferences aqui também.

      return Right(userModel);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      // 1. Limpa a flag de persistência no SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_logged_in', false);

      // Opcional: Se você salvar um token de acesso, limpe-o aqui também
      // await prefs.remove('auth_token');

      // 2. Chama o logout no DataSource (caso precise invalidar o token na API)
      await dataSource.logout();

      return const Right(null);
    } catch (e) {
      // Mesmo que o servidor falhe no logout, garantimos que localmente o usuário saiu
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> checkAuthStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isLoggedIn = prefs.getBool('is_logged_in') ?? false;
      return Right(isLoggedIn);
    } catch (e) {
      return const Right(false);
    }
  }
}
