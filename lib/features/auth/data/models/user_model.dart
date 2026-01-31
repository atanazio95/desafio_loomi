import 'package:desafio_loomi_flutter/features/auth/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({required super.login, required super.password});
  Map<String, dynamic> toJson() {
    return {"login": login, "password": password};
  }

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(login: entity.login, password: entity.password);
  }
}
