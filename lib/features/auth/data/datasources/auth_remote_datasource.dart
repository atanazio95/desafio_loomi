import 'package:desafio_loomi_flutter/core/errors/failures.dart';
import 'package:desafio_loomi_flutter/core/network/dio_client.dart';
import 'package:desafio_loomi_flutter/features/auth/data/models/auth_model.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthRemoteDatasource {
  Future<bool> login(String username, String password);
  Future<AuthModel> register(String username, String password);
  Future<void> logout();
  Future<bool> checkAuthStatus();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDatasource {
  final DioClient dioClient;
  final SharedPreferences sharedPreferences;

  AuthRemoteDataSourceImpl({
    required this.dioClient,
    required this.sharedPreferences,
  });

  @override
  Future<bool> login(String username, String password) async {
    try {
      final userModel = AuthModel(login: username, password: password);

      final response = await dioClient.dio.post(
        '/auth',
        data: userModel.toJson(),
        options: Options(responseType: ResponseType.plain),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        throw ServerFailure();
      }
    } on DioException {
      throw ServerFailure();
    } catch (e) {
      throw ServerFailure();
    }
  }

  @override
  Future<AuthModel> register(String login, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    return AuthModel(login: login, password: password);
  }

  @override
  Future<void> logout() async {
    await sharedPreferences.setBool('is_logged_in', false);
  }

  @override
  Future<bool> checkAuthStatus() async {
    return sharedPreferences.getBool('is_logged_in') ?? false;
  }
}
