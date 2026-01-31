import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/dio_client.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDatasource {
  Future<bool> login(String username, String password);
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
      final userModel = UserModel(login: username, password: password);

      final response = await dioClient.dio.post(
        '/auth',
        data: userModel.toJson(),
        options: Options(responseType: ResponseType.plain),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        await sharedPreferences.setBool('is_logged_in', true);
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
  Future<void> logout() async {
    await sharedPreferences.remove('is_logged_in');
    await sharedPreferences.remove('auth_token');
  }

  @override
  Future<bool> checkAuthStatus() async {
    return sharedPreferences.getBool('is_logged_in') ?? false;
  }
}
