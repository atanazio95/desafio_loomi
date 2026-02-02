import 'package:desafio_loomi_flutter/features/user/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.language,
    required super.dateFormat,
    required super.timezone,
    super.address,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id'].toString()) ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      language: json['language'] ?? '',
      dateFormat: json['dateFormat'] ?? '',
      timezone: json['timezone'] ?? '',
      address: json['address'] != null
          ? AddressModel.fromJson(json['address'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'language': language,
      'dateFormat': dateFormat,
      'timezone': timezone,
      'address': address != null
          ? {
              'zipCode': address!.zipCode,
              'country': address!.country,
              'street': address!.street,
              'number': address!.number,
              'complement': address!.complement,
              'neighborhood': address!.neighborhood,
              'city': address!.city,
              'state': address!.state,
            }
          : null,
    };
  }
}

class AddressModel extends AddressEntity {
  const AddressModel({
    required super.zipCode,
    required super.country,
    required super.street,
    required super.number,
    required super.complement,
    required super.neighborhood,
    required super.city,
    required super.state,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      zipCode: json['zipCode'] ?? '',
      country: json['country'] ?? '',
      street: json['street'] ?? '',
      number: json['number'] ?? '',
      complement: json['complement'] ?? '',
      neighborhood: json['neighborhood'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
    );
  }
}
