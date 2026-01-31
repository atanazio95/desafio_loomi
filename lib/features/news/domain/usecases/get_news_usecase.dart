import 'package:dartz/dartz.dart';
import 'package:desafio_loomi_flutter/core/errors/failures.dart';
import 'package:desafio_loomi_flutter/features/news/domain/entities/news_entity.dart';
import 'package:desafio_loomi_flutter/features/news/domain/repositories/news_repository.dart';

// Caso você não tenha a classe 'UseCase' genérica no core, pode remover o 'extends UseCase<...>'
class GetNewsUseCase {
  final NewsRepository repository;

  GetNewsUseCase(this.repository);

  Future<Either<Failure, List<NewsEntity>>> call(int page) async {
    return await repository.getNews(page);
  }
}
