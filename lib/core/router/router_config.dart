import 'package:desafio_loomi_flutter/core/di/injection_container.dart';
import 'package:desafio_loomi_flutter/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:desafio_loomi_flutter/features/auth/presentation/pages/login_page.dart';
import 'package:desafio_loomi_flutter/features/auth/presentation/pages/splash_page.dart';
import 'package:desafio_loomi_flutter/features/news/domain/entities/news_entity.dart';
import 'package:desafio_loomi_flutter/features/news/presentation/bloc/news_bloc.dart';
import 'package:desafio_loomi_flutter/features/news/presentation/bloc/news_event.dart';
import 'package:desafio_loomi_flutter/features/news/presentation/pages/news_details_page.dart';
import 'package:desafio_loomi_flutter/features/news/presentation/pages/news_page.dart';
import 'package:desafio_loomi_flutter/features/profile/presentation/pages/edit_profile_page.dart';
import 'package:desafio_loomi_flutter/features/profile/presentation/pages/profile_page.dart';
import 'package:desafio_loomi_flutter/features/user/presentation/bloc/user_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final routerConfig = GoRouter(
  initialLocation: '/',
  routes: [
    // initial route of splash
    GoRoute(
      path: '/',
      builder: (context, state) => BlocProvider(
        create: (_) => sl<AuthBloc>(),
        child: const SplashPage(),
      ),
    ),

    // login route
    GoRoute(
      path: '/login',
      builder: (context, state) =>
          BlocProvider(create: (_) => sl<AuthBloc>(), child: const LoginPage()),
    ),

    // news route
    GoRoute(
      path: '/news',
      builder: (context, state) =>
          BlocProvider(create: (_) => sl<NewsBloc>(), child: const NewsPage()),
      routes: [
        GoRoute(
          path: 'details',
          builder: (context, state) {
            final news = state.extra as NewsEntity;
            return NewsDetailsPage(news: news);
          },
        ),
      ],
    ),

    GoRoute(
      path: '/profile',
      builder: (context, state) {
        return MultiBlocProvider(
          providers: [
            BlocProvider.value(value: sl<AuthBloc>()),
            // Adicionamos o UserBloc e já chamamos o evento de buscar
            BlocProvider(create: (_) => sl<UserBloc>()..add(GetUserProfile())),
            BlocProvider(create: (_) => sl<NewsBloc>()..add(GetSavedNews())),
          ],
          child: const ProfilePage(),
        );
      },
    ),
    // Rota de Edição de Perfil
    GoRoute(
      path: '/edit-profile',
      builder: (context, state) {
        // 1. Verifica se o extra existe e é do tipo correto
        final extraBloc = state.extra is UserBloc
            ? state.extra as UserBloc
            : null;

        if (extraBloc != null) {
          // CENÁRIO A: Navegação normal (Veio do Perfil)
          // Reutilizamos o bloc existente (já com dados carregados)
          return BlocProvider.value(
            value: extraBloc,
            child: const EditProfilePage(),
          );
        } else {
          // CENÁRIO B: Hot Reload, Deep Link ou URL direta
          // Criamos uma nova instância e buscamos os dados do zero
          return BlocProvider(
            create: (_) => sl<UserBloc>()..add(GetUserProfile()),
            child: const EditProfilePage(),
          );
        }
      },
    ),
  ],
);
