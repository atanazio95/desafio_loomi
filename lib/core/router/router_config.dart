import 'package:desafio_loomi_flutter/core/di/injection_container.dart';
import 'package:desafio_loomi_flutter/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:desafio_loomi_flutter/features/auth/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final routerConfig = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => BlocProvider(
        create: (_) => sl<AuthBloc>(), // Injeta o Bloc aqui!
        child: const LoginPage(),
      ),
    ),
    GoRoute(
      path: '/news',
      builder: (context, state) =>
          const Scaffold(body: Center(child: Text("HOME - Em breve"))),
    ),
  ],
);
