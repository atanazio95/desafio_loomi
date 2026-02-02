import 'package:desafio_loomi_flutter/features/user/domain/usecases/update_user_profile_usecase.dart';
import 'package:dio/dio.dart'; // <--- ADICIONE ESTE IMPORT
import 'package:desafio_loomi_flutter/core/network/dio_client.dart';
import 'package:desafio_loomi_flutter/core/services/favorites_manager.dart';
import 'package:desafio_loomi_flutter/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:desafio_loomi_flutter/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:desafio_loomi_flutter/features/auth/domain/repositories/auth_repository.dart';
import 'package:desafio_loomi_flutter/features/auth/domain/usecases/check_auth_status_usecase.dart';
import 'package:desafio_loomi_flutter/features/auth/domain/usecases/login_usecase.dart';
import 'package:desafio_loomi_flutter/features/auth/domain/usecases/register_usecase.dart';
import 'package:desafio_loomi_flutter/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:desafio_loomi_flutter/features/news/data/datasources/news_remote_datasource_impl.dart';
import 'package:desafio_loomi_flutter/features/news/data/repositories/news_repository_impl.dart';
import 'package:desafio_loomi_flutter/features/news/domain/repositories/news_repository.dart';
import 'package:desafio_loomi_flutter/features/news/domain/usecases/get_news_details_usecase.dart';
import 'package:desafio_loomi_flutter/features/news/domain/usecases/get_news_usecase.dart';
import 'package:desafio_loomi_flutter/features/news/presentation/bloc/details/news_details_bloc.dart';
import 'package:desafio_loomi_flutter/features/news/presentation/bloc/news_bloc.dart';
import 'package:desafio_loomi_flutter/features/user/data/datasources/user_datasources.dart';
import 'package:desafio_loomi_flutter/features/user/data/repositories/user_repository_impl.dart';
import 'package:desafio_loomi_flutter/features/user/domain/repositories/user_repository.dart';
import 'package:desafio_loomi_flutter/features/user/domain/usecases/get_user_profile_usecase.dart';
import 'package:desafio_loomi_flutter/features/user/presentation/bloc/user_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ! Features - Auth
  sl.registerFactory(
    () => AuthBloc(
      loginUseCase: sl(),
      registerUseCase: sl(),
      authRepository: sl(),
      checkAuthStatusUseCase: sl(),
    ),
  );

  // UseCases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
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
  sl.registerLazySingleton(() => FavoritesManager(sharedPreferences: sl()));

  // ! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // --- CORREÇÃO AQUI ---
  // Registramos o Dio puro para que o UserDataSourceImpl possa encontrá-lo
  if (!sl.isRegistered<Dio>()) {
    sl.registerLazySingleton(() => Dio());
  }
  // ---------------------

  // ! Features - News

  // UseCases
  sl.registerLazySingleton(() => GetNewsUseCase(sl()));
  sl.registerLazySingleton(() => GetNewsDetailsUseCase(sl()));

  // Repository
  sl.registerLazySingleton<NewsRepository>(
    () => NewsRepositoryImpl(remoteDataSource: sl()),
  );

  // Data Sources
  sl.registerLazySingleton<NewsRemoteDataSource>(
    () => NewsRemoteDataSourceImpl(dioClient: sl()),
  );

  // Presentation (Blocs)
  sl.registerFactory(() => NewsBloc(getNewsUseCase: sl()));
  sl.registerFactory(
    () => NewsDetailsBloc(getNewsDetailsUseCase: sl(), favoritesManager: sl()),
  );

  // ! Features - User

  // Bloc
  sl.registerFactory(
    () => UserBloc(
      getUserProfileUseCase: sl(),
      updateUserProfileUseCase: sl(), // <--- Adicione isso
    ),
  );
  // UseCases
  sl.registerLazySingleton(() => GetUserProfileUseCase(sl()));
  sl.registerLazySingleton(() => UpdateUserProfileUseCase(sl()));

  // Repository
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(dataSource: sl()),
  );

  // Data Source
  sl.registerLazySingleton<UserDataSource>(() => UserDataSourceImpl(dio: sl()));
}
