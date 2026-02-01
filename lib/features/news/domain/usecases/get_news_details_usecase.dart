import 'package:dartz/dartz.dart';
import 'package:desafio_loomi_flutter/core/errors/failures.dart';
import 'package:desafio_loomi_flutter/features/news/domain/entities/news_entity.dart';
import 'package:desafio_loomi_flutter/features/news/domain/repositories/news_repository.dart';

class GetNewsDetailsUseCase {
  final NewsRepository repository;

  GetNewsDetailsUseCase(this.repository);

  Future<Either<Failure, NewsEntity>> call(String id) async {
    return await repository.getNewsDetails(id);
  }
}
