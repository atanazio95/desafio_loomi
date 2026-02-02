import 'package:equatable/equatable.dart';

class AuthEntity extends Equatable {
  final String login;
  final String password;
  const AuthEntity({required this.login, required this.password});
  @override
  List<Object?> get props => [login, password];
}
