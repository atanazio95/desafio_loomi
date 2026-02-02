import 'package:desafio_loomi_flutter/features/auth/domain/entities/auth_entity.dart';

class AuthModel extends AuthEntity {
  const AuthModel({required super.login, required super.password});
  Map<String, dynamic> toJson() {
    return {"login": login, "password": password};
  }

  factory AuthModel.fromEntity(AuthEntity entity) {
    return AuthModel(login: entity.login, password: entity.password);
  }
}
