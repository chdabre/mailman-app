import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:mailman/entity/user_entity.dart';

@immutable
class User extends Equatable {
  final int id;
  final String? username;
  final String? email;
  final String? firstName;
  final String? lastName;

  const User({
    required this.id,
    this.username,
    this.email,
    this.firstName,
    this.lastName,
  });

  static User fromEntity(UserEntity entity) =>
      User(
        id: entity.id,
        username: entity.username,
        email: entity.email,
        firstName: entity.firstName,
        lastName: entity.lastName,
      );

  String getInitials() {
    return username?.substring(0, 2).toUpperCase() ?? "";
  }

  @override
  List<Object?> get props => [
    id,
  ];
}