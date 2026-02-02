// lib/features/auth/presentation/pages/splash_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool _canNavigate = false;
  AuthState? _pendingState;

  @override
  void initState() {
    super.initState();
    _startSplash();
  }

  Future<void> _startSplash() async {
    // 1. Dispara a verificação no SharedPreferences
    context.read<AuthBloc>().add(AuthCheckRequested());

    // 2. Aguarda o tempo visual da marca (1.5 segundos)
    await Future.delayed(const Duration(milliseconds: 1500));

    if (!mounted) return;

    // 3. Verifica se o Bloc já deu uma resposta enquanto o delay acontecia
    final currentState = context.read<AuthBloc>().state;

    if (currentState is AuthAuthenticated ||
        currentState is AuthUnauthenticated ||
        currentState is AuthError) {
      _navigate(currentState);
    } else {
      // Se ainda estiver em AuthInitial ou AuthLoading, libera para o Listener navegar depois
      setState(() {
        _canNavigate = true;
      });
    }
  }

  void _navigate(AuthState state) {
    if (state is AuthAuthenticated) {
      context.go('/news'); // Altere para sua rota principal
    } else {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (previous, current) =>
          current is AuthAuthenticated ||
          current is AuthUnauthenticated ||
          current is AuthError,
      listener: (context, state) {
        if (_canNavigate) {
          _navigate(state);
        } else {
          // Se o check for mais rápido que 1.5s, guardamos o resultado aqui
          _pendingState = state;
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF1E50B7),
        body: Center(
          child: Text(
            'Nortus',
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 48,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
