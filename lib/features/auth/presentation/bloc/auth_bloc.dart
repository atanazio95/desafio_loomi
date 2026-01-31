import 'package:desafio_loomi_flutter/features/auth/domain/entities/user_entity.dart';
import 'package:desafio_loomi_flutter/features/auth/domain/repositories/auth_repository.dart';
import 'package:desafio_loomi_flutter/features/auth/domain/usecases/login_usecase.dart';
import 'package:desafio_loomi_flutter/features/auth/presentation/bloc/auth_event.dart';
import 'package:desafio_loomi_flutter/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final AuthRepository authRepository;

  AuthBloc({required this.loginUseCase, required this.authRepository})
    : super(AuthInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
    on<CheckAuthStatus>(_onCheckAuthStatus);
    on<LogoutRequested>(_onLogoutRequested);
  }
  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await loginUseCase(
      UserEntity(login: event.username, password: event.password),
    );

    result.fold(
      (failure) => emit(
        const AuthError(
          message: "Erro ao realizar login. Verifique suas credenciais.",
        ),
      ),
      (success) => emit(AuthAuthenticated()),
    );
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatus event,
    Emitter<AuthState> emit,
  ) async {
    final result = await authRepository.checkAuthStatus();
    result.fold(
      (failure) => emit(AuthUnauthenticated()),
      (isLogged) =>
          isLogged ? emit(AuthAuthenticated()) : emit(AuthUnauthenticated()),
    );
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await authRepository.logout();
    emit(AuthUnauthenticated());
  }
}
