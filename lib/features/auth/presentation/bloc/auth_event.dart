import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class LoginSubmitted extends AuthEvent {
  final String username;
  final String password;
  final bool keepLoggedIn; // Adicione este campo

  LoginSubmitted({
    required this.username,
    required this.password,
    this.keepLoggedIn = false, // Adicione ao construtor
  });
}

class LogoutRequested extends AuthEvent {}

class AuthCheckRequested extends AuthEvent {}
