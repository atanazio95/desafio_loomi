import 'package:dartz/dartz.dart';
import 'package:desafio_loomi_flutter/core/errors/failures.dart';

abstract class CategoriesRepository {
  Future<Either<Failure, List<String>>> getCategories();
}
