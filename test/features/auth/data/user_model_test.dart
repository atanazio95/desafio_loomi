import 'package:desafio_loomi_flutter/features/auth/data/models/auth_model.dart';
import 'package:desafio_loomi_flutter/features/auth/domain/entities/auth_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const tLogin = 'jeorge@loomi.com';
  const tPassword = '123';
  const tAuthEntity = AuthEntity(login: tLogin, password: tPassword);
  const tAuthModel = AuthModel(login: tLogin, password: tPassword);

  group('AuthModel', () {
    test('is a subclass of AuthEntity', () {
      expect(tAuthModel, isA<AuthEntity>());
    });

    test('fromEntity creates AuthModel from AuthEntity', () {
      final result = AuthModel.fromEntity(tAuthEntity);
      expect(result, tAuthModel);
    });

    test('toJson returns Map with login and password', () {
      final result = tAuthModel.toJson();
      final expectedMap = {'login': tLogin, 'password': tPassword};
      expect(result, expectedMap);
    });
  });
}
