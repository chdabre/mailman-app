import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class CredentialsEntity extends Equatable {
  static const String _fieldId = 'id';
  static const String _fieldAccessToken = 'access_token';
  static const String _fieldRefreshToken = 'refresh_token';
  static const String _fieldExpiresAt = 'expires_at';
  static const String _fieldRefreshedAt = 'refreshed_at';

  final int? id;
  final String? accessToken;
  final String? refreshToken;
  final DateTime? expiresAt;
  final DateTime? refreshedAt;

  const CredentialsEntity({
    this.id,
    this.accessToken,
    this.refreshToken,
    this.expiresAt,
    this.refreshedAt
  });

  static CredentialsEntity fromJson(Map<String, dynamic> json) =>
      CredentialsEntity(
          id: json[_fieldId],
          accessToken: json[_fieldAccessToken],
          refreshToken: json[_fieldRefreshToken],
          expiresAt: json.containsKey(_fieldExpiresAt) ? DateTime.parse(json[_fieldExpiresAt]) : null,
          refreshedAt: json[_fieldRefreshedAt] != null ? DateTime.parse(json[_fieldRefreshedAt]) : null,
      );

  Map<String, dynamic> toJson() => {
    if (id != null) _fieldId: id,
    if (accessToken != null) _fieldAccessToken: accessToken,
    if (refreshToken != null) _fieldRefreshToken: refreshToken,
    if (expiresAt != null) _fieldExpiresAt: expiresAt!.toIso8601String(),
  };

  @override
  List<Object?> get props => [
    id,
    accessToken,
    refreshToken,
    expiresAt,
    refreshedAt,
  ];
}