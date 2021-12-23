import 'package:equatable/equatable.dart';

abstract class AuthenticationState extends Equatable {}

class Uninitialized extends AuthenticationState {
  @override
  List<Object> get props => [];

  @override
  String toString() => 'Uninitialized';
}

class LoggingIn extends AuthenticationState {
  @override
  List<Object> get props => [];

  @override
  String toString() => 'LoggingIn';
}


class LoginResult extends AuthenticationState {
  final bool success;
  final String? errorMessage;

  LoginResult({
    required this.success,
    this.errorMessage
  });

  @override
  List<Object?> get props => [
    success,
    errorMessage
  ];
}

class Authenticated extends AuthenticationState {
  @override
  List<Object> get props => [];

  @override
  String toString() => 'Authenticated';
}

class Unauthenticated extends AuthenticationState {
  @override
  List<Object> get props => [];

  @override
  String toString() => 'Unauthenticated';
}
