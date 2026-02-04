import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:desafio_loomi_flutter/core/network/dio_client.dart';
import 'package:desafio_loomi_flutter/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:desafio_loomi_flutter/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:desafio_loomi_flutter/features/auth/domain/repositories/auth_repository.dart';
import 'package:desafio_loomi_flutter/features/auth/domain/usecases/check_auth_status_usecase.dart';
import 'package:desafio_loomi_flutter/features/auth/domain/usecases/login_usecase.dart';
import 'package:desafio_loomi_flutter/features/auth/domain/usecases/register_usecase.dart';
import 'package:desafio_loomi_flutter/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:desafio_loomi_flutter/features/news/data/datasources/news_local_datasource.dart';
import 'package:desafio_loomi_flutter/features/news/data/datasources/news_local_datasource_impl.dart';
import 'package:desafio_loomi_flutter/features/news/data/datasources/news_remote_datasource_impl.dart';
import 'package:desafio_loomi_flutter/features/news/data/repositories/news_repository_impl.dart';
import 'package:desafio_loomi_flutter/features/news/domain/repositories/news_repository.dart';
import 'package:desafio_loomi_flutter/features/news/domain/usecases/get_news_details_usecase.dart';
import 'package:desafio_loomi_flutter/features/news/domain/usecases/get_news_usecase.dart';
import 'package:desafio_loomi_flutter/features/categories/data/datasources/categories_remote_datasource.dart';
import 'package:desafio_loomi_flutter/features/categories/data/datasources/categories_remote_datasource_impl.dart';
import 'package:desafio_loomi_flutter/features/categories/data/repositories/categories_repository_impl.dart';
import 'package:desafio_loomi_flutter/features/categories/domain/repositories/categories_repository.dart';
import 'package:desafio_loomi_flutter/features/categories/domain/usecases/get_categories_usecase.dart';
import 'package:desafio_loomi_flutter/features/categories/presentation/cubit/categories_cubit.dart';
import 'package:desafio_loomi_flutter/features/news/presentation/bloc/news_bloc.dart';
import 'package:desafio_loomi_flutter/features/user/data/datasources/user_datasources.dart';
import 'package:desafio_loomi_flutter/features/user/data/repositories/user_repository_impl.dart';
import 'package:desafio_loomi_flutter/features/user/domain/repositories/user_repository.dart';
import 'package:desafio_loomi_flutter/features/user/domain/usecases/get_user_profile_usecase.dart';
import 'package:desafio_loomi_flutter/features/user/domain/usecases/update_user_profile_usecase.dart';
import 'package:desafio_loomi_flutter/features/user/presentation/bloc/user_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // Core
  sl.registerLazySingleton(() => DioClient());

  // Features - Auth
  sl.registerFactory(
    () => AuthBloc(
      loginUseCase: sl(),
      registerUseCase: sl(),
      authRepository: sl(),
      checkAuthStatusUseCase: sl(),
    ),
  );
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => CheckAuthStatusUseCase(sl()));
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      dataSource: sl(),
      sharedPreferences: sl(),
    ),
  );
  sl.registerLazySingleton<AuthRemoteDatasource>(
    () => AuthRemoteDataSourceImpl(
      dioClient: sl(),
      sharedPreferences: sl(),
    ),
  );

  // Features - News
  sl.registerLazySingleton(() => GetNewsUseCase(sl()));
  sl.registerLazySingleton(() => GetNewsDetailsUseCase(sl()));
  sl.registerLazySingleton<NewsLocalDataSource>(
    () => NewsLocalDataSourceImpl(sharedPreferences: sl()),
  );
  sl.registerLazySingleton<NewsRepository>(
    () => NewsRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );
  sl.registerLazySingleton<NewsRemoteDataSource>(
    () => NewsRemoteDataSourceImpl(dioClient: sl()),
  );

  // Features - Categories (drawer)
  sl.registerLazySingleton<CategoriesRemoteDataSource>(
    () => CategoriesRemoteDataSourceImpl(dioClient: sl()),
  );
  sl.registerLazySingleton<CategoriesRepository>(
    () => CategoriesRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton(() => GetCategoriesUseCase(sl()));
  sl.registerLazySingleton(() => CategoriesCubit(sl()));

  sl.registerLazySingleton(() => NewsBloc(
        getNewsUseCase: sl(),
        getNewsDetailsUseCase: sl(),
      ));

  // Features - User
  sl.registerLazySingleton(
    () => UserBloc(
      getUserProfileUseCase: sl(),
      updateUserProfileUseCase: sl(),
    ),
  );
  sl.registerLazySingleton(() => GetUserProfileUseCase(sl()));
  sl.registerLazySingleton(() => UpdateUserProfileUseCase(sl()));
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(dataSource: sl()),
  );
  sl.registerLazySingleton<UserDataSource>(
    () => UserDataSourceImpl(dioClient: sl()),
  );
}
