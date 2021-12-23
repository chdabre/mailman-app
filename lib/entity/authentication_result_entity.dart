import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class AuthenticationResultEntity extends Equatable {
  static const String _fieldToken = 'key';

  final String token;

  const AuthenticationResultEntity({
    required this.token,
  });

  static AuthenticationResultEntity fromJson(Map<String, dynamic> json) =>
      AuthenticationResultEntity(
          token: json[_fieldToken]
      );

  @override
  List<Object?> get props => [
    token,
  ];
}