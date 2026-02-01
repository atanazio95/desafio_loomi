import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  // Se possivel voltar para adicionar erros especificos

  @override
  List<Object> get props => [];
}

// erro or timeout
class ServerFailure extends Failure {}

// erro offline read or save
class CacheFailure extends Failure {}
