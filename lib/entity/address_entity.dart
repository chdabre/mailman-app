import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class AddressEntity extends Equatable {
  static const String _fieldId = 'id';
  static const String _fieldFirstName = 'firstname';
  static const String _fieldLastName = 'lastname';
  static const String _fieldStreet = 'street';
  static const String _fieldCity = 'city';
  static const String _fieldZipCode = 'zipcode';
  static const String _fieldIsPrimary = 'is_primary';

  final int? id;
  final String firstName;
  final String lastName;
  final String street;
  final String city;
  final String zipCode;
  final bool isPrimary;

  const AddressEntity({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.street,
    required this.city,
    required this.zipCode,
    this.isPrimary = false,
  });

  static AddressEntity fromJson(Map<String, dynamic> json) =>
      AddressEntity(
        id: json[_fieldId],
        firstName: json[_fieldFirstName],
        lastName: json[_fieldLastName],
        street: json[_fieldStreet],
        city: json[_fieldCity],
        zipCode: json[_fieldZipCode],
        isPrimary: json[_fieldIsPrimary],
      );

  Map<String, dynamic> toJson() => {
    if (id != null) _fieldId: id,
    _fieldFirstName: firstName,
    _fieldLastName: lastName,
    _fieldStreet: street,
    _fieldCity: city,
    _fieldZipCode: zipCode,
    _fieldIsPrimary: isPrimary,
  };

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