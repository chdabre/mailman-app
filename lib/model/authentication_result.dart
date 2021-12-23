import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:mailman/entity/authentication_result_entity.dart';

@immutable
class AuthenticationResult  extends Equatable {
  final String token;

  const AuthenticationResult({
    required this.token,
  });

  static AuthenticationResult fromEntity(AuthenticationResultEntity entity) =>
      AuthenticationResult(
          token: entity.token
      );

  @override
  List<Object?> get props => [
    token,
  ];
}