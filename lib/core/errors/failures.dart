import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  // Se possivel voltar para adicionar erros especificos

  @override
  List<Object> get props => [];
}

// erro ou timeout
class ServerFailure extends Failure {}

// erro de persistencia ler ou salvar
class CacheFailure extends Failure {}
