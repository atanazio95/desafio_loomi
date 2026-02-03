import 'package:dio/dio.dart';
import '../../../../core/errors/failures.dart';
import '../models/user_model.dart';

abstract class UserDataSource {
  Future<UserModel> getUserProfile();
  Future<void> updateUserProfile(UserModel user);
}

class UserDataSourceImpl implements UserDataSource {
  final Dio dio;

  UserModel? _memoryCache;

  UserDataSourceImpl({required this.dio});

  @override
  Future<UserModel> getUserProfile() async {
    if (_memoryCache != null) {
      return _memoryCache!;
    }

    try {
      final response = await dio.get(
        'https://flutter-challenge.wiremockapi.cloud/user',
      );

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
      // 3 second delay (challenge requirement)
      await Future.delayed(const Duration(seconds: 3));

      await dio.patch(
        'https://flutter-challenge.wiremockapi.cloud/user',
        data: user.toJson(),
      );

      _memoryCache = user;
    } catch (e) {
      throw ServerFailure();
    }
  }
}
