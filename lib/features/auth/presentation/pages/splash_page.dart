import 'package:desafio_loomi_flutter/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:desafio_loomi_flutter/features/auth/presentation/bloc/auth_event.dart';
import 'package:desafio_loomi_flutter/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

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
    // Inicia verificação de auth
    context.read<AuthBloc>().add(AuthCheckRequested());

    // Delay mínimo para exibir o "Nortus"
    await Future.delayed(const Duration(milliseconds: 1500));

    if (!mounted) return;

    _canNavigate = true;

    // Se já recebeu o estado, navega agora
    if (_pendingState != null) {
      _navigate(_pendingState!);
    }
  }

  void _navigate(AuthState state) {
    if (state is AuthAuthenticated) {
      context.go('/news');
    } else if (state is AuthUnauthenticated) {
      context.go('/login');
    } else if (state is AuthError) {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (_canNavigate) {
          _navigate(state);
        } else {
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
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }
}
