import 'package:desafio_loomi_flutter/core/errors/failures.dart';
import 'package:desafio_loomi_flutter/core/network/dio_client.dart';
import 'package:desafio_loomi_flutter/features/user/data/models/user_model.dart';

abstract class UserDataSource {
  Future<UserModel> getUserProfile();
  Future<void> updateUserProfile(UserModel user);
}

class UserDataSourceImpl implements UserDataSource {
  final DioClient dioClient;

  UserModel? _memoryCache;

  UserDataSourceImpl({required this.dioClient});

  @override
  Future<UserModel> getUserProfile() async {
    if (_memoryCache != null) {
      return _memoryCache!;
    }

    try {
      final response = await dioClient.dio.get('/user');

      if (response.statusCode == 200) {
        final payload = response.data;
        final userData = payload is Map && payload.containsKey('data')
            ? payload['data']
            : payload;
        final user = UserModel.fromJson(userData);

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
      await Future.delayed(const Duration(seconds: 3));

      await dioClient.dio.patch('/user', data: user.toJson());

      _memoryCache = user;
    } catch (e) {
      throw ServerFailure();
    }
  }
}
