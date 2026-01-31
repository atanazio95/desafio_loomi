import 'package:desafio_loomi_flutter/core/network/dio_client.dart';
import 'package:desafio_loomi_flutter/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:desafio_loomi_flutter/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:desafio_loomi_flutter/features/auth/domain/repositories/auth_repository.dart';
import 'package:desafio_loomi_flutter/features/auth/domain/usecases/check_auth_status_usecase.dart';
import 'package:desafio_loomi_flutter/features/auth/domain/usecases/login_usecase.dart';
import 'package:desafio_loomi_flutter/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:desafio_loomi_flutter/features/news/data/datasources/news_remote_datasource.dart';
import 'package:desafio_loomi_flutter/features/news/data/repositories/news_repository_impl.dart';
import 'package:desafio_loomi_flutter/features/news/domain/repositories/news_repository.dart';
import 'package:desafio_loomi_flutter/features/news/domain/usecases/get_news_usecase.dart';
import 'package:desafio_loomi_flutter/features/news/presentation/bloc/news_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Importe o AuthBloc aqui depois que criarmos ele

final sl = GetIt.instance;

Future<void> init() async {
  // ! Features - Auth
  // Bloc (Vamos registrar depois)
  sl.registerFactory(
    () => AuthBloc(
      loginUseCase: sl(),
      authRepository: sl(),
      checkAuthStatusUseCase: sl(),
    ),
  );

  // UseCases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => CheckAuthStatusUseCase(sl()));

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

  // ! Features - News
  // UseCases
  sl.registerLazySingleton(() => GetNewsUseCase(sl()));

  // Repository
  sl.registerLazySingleton<NewsRepository>(
    () => NewsRepositoryImpl(dataSource: sl()),
  );

  // Data Sources
  sl.registerLazySingleton<NewsRemoteDataSource>(
    () => NewsRemoteDataSourceImpl(dioClient: sl()),
  );

  // Presentation (Bloc)
  sl.registerFactory(() => NewsBloc(getNewsUseCase: sl()));
}
