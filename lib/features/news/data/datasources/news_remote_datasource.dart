import 'package:desafio_loomi_flutter/core/errors/failures.dart';
import 'package:desafio_loomi_flutter/core/network/dio_client.dart';
import 'package:desafio_loomi_flutter/features/news/data/models/news_model.dart';
import 'package:dio/dio.dart';

abstract class NewsRemoteDataSource {
  Future<List<NewsModel>> getNews(int page);
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

      // O Dio já faz o decode para Map ou List
      final dynamic responseData = response.data;
      List<dynamic> list = [];

      // Verifica formato da resposta (Paginação da Loomi)
      if (responseData is Map<String, dynamic> &&
          responseData.containsKey('data')) {
        list = responseData['data'];
      } else if (responseData is List) {
        list = responseData;
      }

      return list.map((e) => NewsModel.fromJson(e)).toList();
    } on DioException catch (e) {
      // Se quiser logar o erro: print(e.message);
      throw ServerFailure();
    } catch (e) {
      throw ServerFailure();
    }
  }
}
