import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class UserEntity extends Equatable {
  static const String _fieldId = 'pk';
  static const String _fieldUsername = 'username';
  static const String _fieldEmail = 'email';
  static const String _fieldFirstName = 'first_name';
  static const String _fieldLastName = 'last_name';


  final int id;
  final String? username;
  final String? email;
  final String? firstName;
  final String? lastName;

  const UserEntity({
    required this.id,
    this.username,
    this.email,
    this.firstName,
    this.lastName,
  });

  static UserEntity fromJson(Map<String, dynamic> json) =>
      UserEntity(
        id: json[_fieldId],
        username: json[_fieldUsername],
        email: json[_fieldEmail],
        firstName: json[_fieldFirstName],
        lastName: json[_fieldLastName],
      );

  @override
  List<Object?> get props => [
    id,
    username,
    email,
    firstName,
    lastName,
  ];
}