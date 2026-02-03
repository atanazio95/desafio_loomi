import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class LoginSubmitted extends AuthEvent {
  final String username;
  final String password;
  final bool keepLoggedIn;

  LoginSubmitted({
    required this.username,
    required this.password,
    this.keepLoggedIn = false,
  });
}

class RegisterSubmitted extends AuthEvent {
  final String username;
  final String password;

  RegisterSubmitted({required this.username, required this.password});
}

class LogoutRequested extends AuthEvent {}

class AuthCheckRequested extends AuthEvent {}
