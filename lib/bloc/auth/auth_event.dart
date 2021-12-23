import 'package:equatable/equatable.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();
}

class AppStarted extends AuthenticationEvent {
  @override
  String toString() => 'AppStarted';

  @override
  List<Object> get props => [];
}

class Login extends AuthenticationEvent {
  final String username;
  final String password;


  const Login(this.username, this.password);

  @override
  String toString() => 'Login';

  @override
  List<Object> get props => [
    username,
    password,
  ];
}

class SignUp extends AuthenticationEvent {
  final String email;
  final String password;


  const SignUp(this.email, this.password);

  @override
  String toString() => 'SignUp';

  @override
  List<Object> get props => [
    email,
    password,
  ];
}

class Logout extends AuthenticationEvent {
  @override
  String toString() => 'Logout';

  @override
  List<Object> get props => [];
}

class LoggedOut extends AuthenticationEvent {
  @override
  String toString() => 'LoggedOut';

  @override
  List<Object> get props => [];
}

class LoggedIn extends AuthenticationEvent {
  @override
  String toString() => 'LoggedIn';

  @override
  List<Object> get props => [];
}