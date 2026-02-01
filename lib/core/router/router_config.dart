import 'package:desafio_loomi_flutter/core/di/injection_container.dart';
import 'package:desafio_loomi_flutter/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:desafio_loomi_flutter/features/auth/presentation/pages/login_page.dart';
import 'package:desafio_loomi_flutter/features/auth/presentation/pages/splash_page.dart';
import 'package:desafio_loomi_flutter/features/news/domain/entities/news_entity.dart';
import 'package:desafio_loomi_flutter/features/news/presentation/bloc/news_bloc.dart';
import 'package:desafio_loomi_flutter/features/news/presentation/pages/news_details_page.dart';
import 'package:desafio_loomi_flutter/features/news/presentation/pages/news_page.dart';
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
  ],
);
