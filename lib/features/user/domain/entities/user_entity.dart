import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final int id;
  final String name;
  final String email;
  final String language;
  final String dateFormat;
  final String timezone;
  final AddressEntity? address;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.language,
    required this.dateFormat,
    required this.timezone,
    this.address,
  });

  @override
  List<Object?> get props => [id, name, email, address];
}

class AddressEntity extends Equatable {
  final String zipCode;
  final String country;
  final String street;
  final String number;
  final String complement;
  final String neighborhood;
  final String city;
  final String state;

  const AddressEntity({
    required this.zipCode,
    required this.country,
    required this.street,
    required this.number,
    required this.complement,
    required this.neighborhood,
    required this.city,
    required this.state,
  });

  @override
  List<Object?> get props => [zipCode, street, number, city, state];
}
