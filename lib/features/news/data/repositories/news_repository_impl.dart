import 'package:dartz/dartz.dart';
import 'package:desafio_loomi_flutter/core/errors/failures.dart';
import 'package:desafio_loomi_flutter/features/news/data/datasources/news_remote_datasource.dart';
import 'package:desafio_loomi_flutter/features/news/domain/entities/news_entity.dart';
import 'package:desafio_loomi_flutter/features/news/domain/repositories/news_repository.dart';

class NewsRepositoryImpl implements NewsRepository {
  final NewsRemoteDataSource remoteDataSource;

  NewsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<NewsEntity>>> getNews(int page) async {
    try {
      final result = await remoteDataSource.getNews(page);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, NewsEntity>> getNewsDetails(String id) async {
    try {
      final result = await remoteDataSource.getNewsDetails(id);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
