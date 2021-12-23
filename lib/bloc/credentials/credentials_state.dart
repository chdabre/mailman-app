import 'package:equatable/equatable.dart';
import 'package:mailman/model/credentials.dart';
import 'package:meta/meta.dart';

@immutable
class CredentialsState extends Equatable {
  final bool loading;
  final bool fetched;

  final List<Credentials> credentialsList;

  const CredentialsState({
    this.loading = false,
    this.fetched = false,
    this.credentialsList = const [],
  });

  CredentialsState copyWith({
    bool? loading,
    bool? fetched,
    List<Credentials>? credentialsList,
  }) {
    return CredentialsState(
      loading: loading ?? this.loading,
      fetched: fetched ?? this.fetched,
      credentialsList: credentialsList ?? this.credentialsList,
    );
  }

  bool hasCredentials() {
    return credentialsList.isNotEmpty;
  }

  @override
  List<Object?> get props => [
    loading,
    fetched,
    credentialsList,
  ];

  @override
  String toString() => 'CredentialsState loading:$loading, fetched:$fetched, credentials: ${credentialsList.length}';
}
