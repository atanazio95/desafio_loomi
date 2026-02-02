import 'package:desafio_loomi_flutter/features/auth/data/models/auth_model.dart';
import 'package:desafio_loomi_flutter/features/auth/domain/entities/auth_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const tLogin = "jeorge@loomi.com";
  const tPassword = "123";

  // Dados de teste
  const tUserEntity = AuthEntity(login: tLogin, password: tPassword);
  const tUserModel = AuthModel(login: tLogin, password: tPassword);

  group('UserModel', () {
    test('deve ser uma subclasse de UserEntity', () {
      expect(tUserModel, isA<AuthEntity>());
    });

    test(
      'fromEntity deve criar um UserModel válido a partir de uma UserEntity',
      () {
        // Act
        final result = AuthModel.fromEntity(tUserEntity);

        // Assert
        expect(result, tUserModel);
      },
    );

    test('toJson deve retornar um Map contendo login e password corretos', () {
      // Act
      final result = tUserModel.toJson();

      // Assert
      final expectedMap = {"login": tLogin, "password": tPassword};
      expect(result, expectedMap);
    });
  });
}
