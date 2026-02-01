import 'package:desafio_loomi_flutter/core/errors/failures.dart';
import 'package:desafio_loomi_flutter/core/network/dio_client.dart';
import 'package:desafio_loomi_flutter/features/news/data/models/news_model.dart';
import 'package:dio/dio.dart';

abstract class NewsRemoteDataSource {
  Future<List<NewsModel>> getNews(int page);
  Future<NewsModel> getNewsDetails(String id);
}

class NewsRemoteDataSourceImpl implements NewsRemoteDataSource {
  final DioClient dioClient;

  NewsRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<List<NewsModel>> getNews(int page) async {
    try {
      final response = await dioClient.dio.get(
        '/news',
        queryParameters: {'page': page},
      );

      final dynamic responseData = response.data;
      List<dynamic> list = [];

      if (responseData is Map<String, dynamic> &&
          responseData.containsKey('data')) {
        list = responseData['data'];
      } else if (responseData is List) {
        list = responseData;
      }

      return list.map((e) => NewsModel.fromJson(e)).toList();
    } on DioException catch (_) {
      throw ServerFailure();
    } catch (_) {
      throw ServerFailure();
    }
  }

  @override
  Future<NewsModel> getNewsDetails(String id) async {
    try {
      final response = await dioClient.dio.get('/news/$id/details');
      return NewsModel.fromJson(response.data);
    } on DioException catch (_) {
      throw ServerFailure();
    } catch (_) {
      throw ServerFailure();
    }
  }
}
