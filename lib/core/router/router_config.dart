import 'package:desafio_loomi_flutter/core/di/injection_container.dart';
import 'package:desafio_loomi_flutter/features/auth/presentation/pages/login_page.dart';
import 'package:desafio_loomi_flutter/features/auth/presentation/pages/splash_page.dart';
import 'package:desafio_loomi_flutter/features/news/domain/entities/news_entity.dart';
import 'package:desafio_loomi_flutter/features/news/presentation/pages/news_details_page.dart';
import 'package:desafio_loomi_flutter/features/news/presentation/pages/news_page.dart';
import 'package:desafio_loomi_flutter/features/profile/presentation/pages/edit_profile_page.dart';
import 'package:desafio_loomi_flutter/features/profile/presentation/pages/profile_page.dart';
import 'package:go_router/go_router.dart';

final routerConfig = GoRouter(
  initialLocation: '/',
  routes: [
    // --- SPLASH ---
    GoRoute(path: '/', builder: (context, state) => const SplashPage()),

    // --- LOGIN ---
    GoRoute(path: '/login', builder: (context, state) => const LoginPage()),

    // --- NEWS (FEED) ---
    GoRoute(
      path: '/news',
      builder: (context, state) => const NewsPage(),
      routes: [
        GoRoute(
          path: 'details',
          builder: (context, state) {
            final args = state.extra as Map<String, dynamic>;
            final news = args['news'] as NewsEntity;
            return NewsDetailsPage(news: news);
          },
        ),
      ],
    ),

    // --- PROFILE ---
    GoRoute(path: '/profile', builder: (context, state) => const ProfilePage()),

    // --- EDIT PROFILE ---
    GoRoute(
      path: '/edit-profile',
      builder: (context, state) => const EditProfilePage(),
    ),
  ],
);
