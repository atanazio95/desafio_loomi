import 'package:desafio_loomi_flutter/core/network/dio_client.dart';
import 'package:desafio_loomi_flutter/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:desafio_loomi_flutter/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:desafio_loomi_flutter/features/auth/domain/repositories/auth_repository.dart';
import 'package:desafio_loomi_flutter/features/auth/domain/usecases/login_usecase.dart';
import 'package:desafio_loomi_flutter/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Importe o AuthBloc aqui depois que criarmos ele

final sl = GetIt.instance;

Future<void> init() async {
  // ! Features - Auth
  // Bloc (Vamos registrar depois)
  // sl.registerFactory(() => AuthBloc(loginUseCase: sl()));

  // UseCases
  sl.registerLazySingleton(() => LoginUseCase(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(dataSource: sl()),
  );

  // Data Sources
  sl.registerLazySingleton<AuthRemoteDatasource>(
    () => AuthRemoteDataSourceImpl(dioClient: sl(), sharedPreferences: sl()),
  );

  // ! Core
  sl.registerLazySingleton(() => DioClient());

  // ! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  sl.registerFactory(() => AuthBloc(loginUseCase: sl(), authRepository: sl()));
}
