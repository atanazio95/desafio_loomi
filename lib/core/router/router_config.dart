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
import 'package:desafio_loomi_flutter/features/user/presentation/bloc/user_event.dart'; // Importante para o GetUserProfile
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final routerConfig = GoRouter(
  initialLocation: '/',
  routes: [
    // --- SPLASH ---
    GoRoute(
      path: '/',
      builder: (context, state) => BlocProvider(
        create: (_) => sl<AuthBloc>(),
        child: const SplashPage(),
      ),
    ),

    // --- LOGIN ---
    GoRoute(
      path: '/login',
      builder: (context, state) =>
          BlocProvider(create: (_) => sl<AuthBloc>(), child: const LoginPage()),
    ),

    // --- NEWS (FEED) ---
    GoRoute(
      path: '/news',
      builder: (context, state) =>
          BlocProvider(create: (_) => sl<NewsBloc>(), child: const NewsPage()),
      // Sub-rotas de News (Opcional manter aqui ou mover para fora)
      routes: [
        GoRoute(
          path: 'details', // Caminho final: /news/details
          builder: (context, state) {
            // 1. Recebendo o Map
            final args = state.extra as Map<String, dynamic>;
            final news = args['news'] as NewsEntity;
            final newsBloc = args['bloc'] as NewsBloc;

            // 2. Passando o Bloc existente via value
            return BlocProvider.value(
              value: newsBloc,
              child: NewsDetailsPage(news: news),
            );
          },
        ),
      ],
    ),

    // --- PROFILE (Movido para o Top Level) ---
    GoRoute(
      path: '/profile',
      builder: (context, state) {
        return MultiBlocProvider(
          providers: [
            BlocProvider.value(value: sl<AuthBloc>()),
            // UserBloc buscando dados ao abrir
            BlocProvider(create: (_) => sl<UserBloc>()..add(GetUserProfile())),
          ],
          child: const ProfilePage(),
        );
      },
    ),

    // --- EDIT PROFILE (Movido para o Top Level) ---
    GoRoute(
      path: '/edit-profile',
      builder: (context, state) {
        // Verifica se recebemos o Bloc da tela anterior
        final extraBloc = state.extra is UserBloc
            ? state.extra as UserBloc
            : null;

        if (extraBloc != null) {
          // Reutiliza o bloc (já com dados)
          return BlocProvider.value(
            value: extraBloc,
            child: const EditProfilePage(),
          );
        } else {
          // Fallback: cria um novo se recarregar a página direto
          return BlocProvider(
            create: (_) => sl<UserBloc>()..add(GetUserProfile()),
            child: const EditProfilePage(),
          );
        }
      },
    ),
  ],
);
