import 'package:dartz/dartz.dart';
import 'package:desafio_loomi_flutter/core/errors/failures.dart';
import 'package:desafio_loomi_flutter/features/news/data/datasources/news_local_datasource.dart';
import 'package:desafio_loomi_flutter/features/news/data/datasources/news_remote_datasource_impl.dart';
import 'package:desafio_loomi_flutter/features/news/data/models/news_model.dart';
import 'package:desafio_loomi_flutter/features/news/domain/entities/news_entity.dart';
import 'package:desafio_loomi_flutter/features/news/domain/repositories/news_repository.dart';

class NewsRepositoryImpl implements NewsRepository {
  final NewsRemoteDataSource remoteDataSource;
  final NewsLocalDataSource localDataSource;

  NewsRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<NewsEntity>>> getNews(int page) async {
    try {
      final result = await remoteDataSource.getNews(page);
      if (page == 1) {
        await localDataSource.saveNewsList(result);
      } else {
        final cached = await localDataSource.getNewsList();
        if (cached != null) {
          final merged = _mergeById(cached, result);
          await localDataSource.saveNewsList(merged);
        } else {
          await localDataSource.saveNewsList(result);
        }
      }
      return Right(result);
    } catch (_) {
      if (page == 1) {
        final cached = await localDataSource.getNewsList();
        if (cached != null && cached.isNotEmpty) {
          return Right(cached);
        }
      }
      return Left(ServerFailure());
    }
  }

  List<NewsModel> _mergeById(List<NewsModel> existing, List<NewsModel> newPage) {
    final byId = <String, NewsModel>{};
    for (final n in existing) {
      byId[n.id] = n;
    }
    for (final n in newPage) {
      byId[n.id] = n;
    }
    return byId.values.toList();
  }

  @override
  Future<Either<Failure, NewsEntity>> getNewsDetails(String id) async {
    try {
      final result = await remoteDataSource.getNewsDetails(id);
      await localDataSource.saveNewsDetail(result);
      return Right(result);
    } catch (_) {
      final cached = await localDataSource.getNewsDetail(id);
      if (cached != null) {
        return Right(cached);
      }
      return Left(ServerFailure());
    }
  }
}
