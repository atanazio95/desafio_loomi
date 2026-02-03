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
    context.read<AuthBloc>().add(AuthCheckRequested());
    await Future.delayed(const Duration(milliseconds: 1500));

    if (!mounted) return;

    final currentState = context.read<AuthBloc>().state;

    if (currentState is AuthAuthenticated ||
        currentState is AuthUnauthenticated ||
        currentState is AuthError) {
      _navigate(currentState);
    } else {
      setState(() {
        _canNavigate = true;
      });
    }
  }

  void _navigate(AuthState state) {
    if (state is AuthAuthenticated) {
      context.go('/news');
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
