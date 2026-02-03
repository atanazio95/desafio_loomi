import 'package:desafio_loomi_flutter/features/user/data/models/user_model.dart';
import 'package:desafio_loomi_flutter/features/user/domain/entities/user_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const tUserModel = UserModel(
    id: 1,
    name: 'Test User',
    email: 'user@test.com',
    language: 'pt-BR',
    dateFormat: 'DD/MM/AA',
    timezone: 'America/Sao_Paulo',
    address: null,
  );

  final tJson = {
    'id': 1,
    'name': 'Test User',
    'email': 'user@test.com',
    'language': 'pt-BR',
    'dateFormat': 'DD/MM/AA',
    'timezone': 'America/Sao_Paulo',
    'address': null,
  };

  final tJsonWithAddress = {
    'id': 1,
    'name': 'Test User',
    'email': 'user@test.com',
    'language': 'pt-BR',
    'dateFormat': 'DD/MM/AA',
    'timezone': 'America/Sao_Paulo',
    'address': {
      'zipCode': '12345',
      'country': 'Brasil',
      'street': 'Rua Teste',
      'number': '100',
      'complement': '',
      'neighborhood': 'Centro',
      'city': 'São Paulo',
      'state': 'SP',
    },
  };

  group('UserModel', () {
    test('deve ser uma subclasse de UserEntity', () {
      expect(tUserModel, isA<UserEntity>());
    });

    test('fromJson deve criar UserModel a partir de JSON', () {
      final result = UserModel.fromJson(tJson);

      expect(result.id, 1);
      expect(result.name, 'Test User');
      expect(result.email, 'user@test.com');
      expect(result.language, 'pt-BR');
      expect(result.dateFormat, 'DD/MM/AA');
      expect(result.timezone, 'America/Sao_Paulo');
      expect(result.address, isNull);
    });

    test('fromJson deve preencher address quando presente', () {
      final result = UserModel.fromJson(tJsonWithAddress);

      expect(result.address, isNotNull);
      expect(result.address!.zipCode, '12345');
      expect(result.address!.country, 'Brasil');
      expect(result.address!.street, 'Rua Teste');
      expect(result.address!.number, '100');
      expect(result.address!.city, 'São Paulo');
      expect(result.address!.state, 'SP');
    });

    test('toJson deve retornar Map com campos corretos', () {
      final result = tUserModel.toJson();

      expect(result['name'], 'Test User');
      expect(result['email'], 'user@test.com');
      expect(result['language'], 'pt-BR');
      expect(result['dateFormat'], 'DD/MM/AA');
      expect(result['timezone'], 'America/Sao_Paulo');
      expect(result['address'], isNull);
    });
  });
}
