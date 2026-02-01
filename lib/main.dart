import 'package:desafio_loomi_flutter/core/router/router_config.dart';
import 'package:desafio_loomi_flutter/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:desafio_loomi_flutter/features/news/presentation/bloc/news_bloc.dart'; // Adicione se necessário
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
    // Usamos MultiBlocProvider para injetar Blocs globais
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          // O di.sl<AuthBloc>() busca a instância configurada no seu GetIt
          create: (context) => di.sl<AuthBloc>(),
        ),
        // Se você quiser que o NewsBloc também seja global:
        // BlocProvider<NewsBloc>(
        //   create: (context) => di.sl<NewsBloc>(),
        // ),
      ],
      child: MaterialApp.router(
        routerConfig: routerConfig,
        title: 'Loomi Challenge',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFE90064)),
          useMaterial3: true,
        ),
      ),
    );
  }
}
