import 'package:desafio_loomi_flutter/core/errors/failures.dart';
import 'package:desafio_loomi_flutter/core/network/dio_client.dart';
import 'package:desafio_loomi_flutter/features/categories/data/datasources/categories_remote_datasource.dart';
import 'package:dio/dio.dart';

class CategoriesRemoteDataSourceImpl implements CategoriesRemoteDataSource {
  final DioClient dioClient;

  CategoriesRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<List<String>> getCategories() async {
    try {
      final response = await dioClient.dio.get('/categories');
      final dynamic data = response.data;
      if (data is Map<String, dynamic> && data.containsKey('data')) {
        final list = data['data'];
        if (list is List) {
          return list.map((e) => e?.toString() ?? '').where((s) => s.isNotEmpty).toList();
        }
      }
      return [];
    } on DioException catch (_) {
      throw ServerFailure();
    } catch (_) {
      throw ServerFailure();
    }
  }
}
