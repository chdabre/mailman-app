import 'package:equatable/equatable.dart';
import 'package:mailman/entity/address_entity.dart';
import 'package:meta/meta.dart';

@immutable
class Address extends Equatable {
  final int? id;
  final String firstName;
  final String lastName;
  final String street;
  final String city;
  final String zipCode;
  final bool isPrimary;


  const Address({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.street,
    required this.city,
    required this.zipCode,
    this.isPrimary = false,
  });

  static Address fromEntity(AddressEntity entity) =>
      Address(
        id: entity.id,
        firstName: entity.firstName,
        lastName: entity.lastName,
        street: entity.street,
        city: entity.city,
        zipCode: entity.zipCode,
        isPrimary: entity.isPrimary,
      );

  AddressEntity toEntity() =>
      AddressEntity(
        id: id,
        firstName: firstName,
        lastName: lastName,
        street: street,
        city: city,
        zipCode: zipCode,
        isPrimary: isPrimary,
      );

  @override
  List<Object?> get props => [
    id,
    firstName,
    lastName,
    street,
    city,
    zipCode,
    isPrimary,
  ];
}