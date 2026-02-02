import 'package:dio/dio.dart';
import '../../../../core/errors/failures.dart';
import '../models/user_model.dart';

abstract class UserDataSource {
  Future<UserModel> getUserProfile();
  Future<void> updateUserProfile(UserModel user);
}

class UserDataSourceImpl implements UserDataSource {
  final Dio dio;

  // Cache em memória para simular persistência
  UserModel? _memoryCache;

  UserDataSourceImpl({required this.dio});

  @override
  Future<UserModel> getUserProfile() async {
    // 1. Se já temos dados no cache, retornamos eles (prioridade)
    if (_memoryCache != null) {
      return _memoryCache!;
    }

    try {
      final response = await dio.get(
        'https://flutter-challenge.wiremockapi.cloud/user',
      );

      if (response.statusCode == 200) {
        // [CORREÇÃO] O JSON vem como {"data": {...}}, então precisamos acessar ['data']
        // Se response.data já for o Map, acessamos a chave 'data'.
        final payload = response.data;
        final userData = payload is Map && payload.containsKey('data')
            ? payload['data']
            : payload;

        // Agora userData contém { "id": 1, "name": "Pedro", ... }
        final user = UserModel.fromJson(userData);

        // Salvamos no cache
        _memoryCache = user;

        return user;
      } else {
        throw ServerFailure();
      }
    } catch (e) {
      throw ServerFailure();
    }
  }

  @override
  Future<void> updateUserProfile(UserModel user) async {
    try {
      // Delay de 3 segundos (Regra do Desafio)
      await Future.delayed(const Duration(seconds: 3));

      await dio.patch(
        'https://flutter-challenge.wiremockapi.cloud/user',
        data: user.toJson(),
      );

      // SUCESSO: Atualizamos a memória local com os dados novos
      _memoryCache = user;
    } catch (e) {
      throw ServerFailure();
    }
  }
}
