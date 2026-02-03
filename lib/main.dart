import 'package:desafio_loomi_flutter/core/di/injection_container.dart';
import 'package:desafio_loomi_flutter/core/router/router_config.dart';
import 'package:desafio_loomi_flutter/core/theme/app_colors.dart';
import 'package:desafio_loomi_flutter/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:desafio_loomi_flutter/features/categories/presentation/cubit/categories_cubit.dart';
import 'package:desafio_loomi_flutter/features/news/presentation/bloc/news_bloc.dart';
import 'package:desafio_loomi_flutter/features/user/presentation/bloc/user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/di/injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MultiBlocProvider injects global Blocs
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (_) => sl<AuthBloc>()),
        BlocProvider<NewsBloc>(create: (_) => sl<NewsBloc>()),
        BlocProvider<UserBloc>(create: (_) => sl<UserBloc>()),
        BlocProvider<CategoriesCubit>(create: (_) => sl<CategoriesCubit>()),
      ],
      child: MaterialApp.router(
        routerConfig: routerConfig,
        title: 'Loomi Challenge',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
          useMaterial3: true,
          progressIndicatorTheme: const ProgressIndicatorThemeData(
            color: AppColors.loading,
            circularTrackColor: Colors.white24,
          ),
        ),
      ),
    );
  }
}
