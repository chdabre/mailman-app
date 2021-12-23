import 'package:equatable/equatable.dart';
import 'package:mailman/model/user.dart';
import 'package:meta/meta.dart';

@immutable
class UserDataState extends Equatable {
  final bool loading;
  final bool fetched;

  final User? user;

  const UserDataState({
    this.loading = false,
    this.fetched = false,
    this.user,
  });

  UserDataState copyWith({
    bool? loading,
    bool? fetched,
    User? user,
  }) {
    return UserDataState(
      loading: loading ?? this.loading,
      fetched: fetched ?? this.fetched,
      user: user ?? this.user,
    );
  }

  @override
  List<Object?> get props => [
    loading,
    fetched,
  ];

  @override
  String toString() => 'UserDataState loading:$loading, fetched:$fetched, user: $user';
}
