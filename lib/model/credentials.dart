import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:mailman/entity/credentials_entity.dart';

@immutable
class Credentials extends Equatable{
  final int? id;
  final String? accessToken;
  final String? refreshToken;
  final DateTime? expiresAt;
  final DateTime? refreshedAt;

  const Credentials({
    this.id,
    this.accessToken,
    this.refreshToken,
    this.expiresAt,
    this.refreshedAt
  });

  static Credentials fromEntity(CredentialsEntity entity) =>
      Credentials(
        id: entity.id,
        accessToken: entity.accessToken,
        refreshToken: entity.refreshToken,
        expiresAt: entity.expiresAt,
        refreshedAt: entity.refreshedAt,
      );

  CredentialsEntity toEntity() =>
      CredentialsEntity(id: id, accessToken: accessToken, refreshToken: refreshToken, expiresAt: expiresAt);

  @override
  String toString() {
    return "Credentials ${accessToken?.substring(0,5)}... | expire $expiresAt";
  }

  @override
  List<Object?> get props => [
    id
  ];
}