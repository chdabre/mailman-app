import 'package:equatable/equatable.dart';

abstract class CredentialsEvent extends Equatable {
  const CredentialsEvent();
}

class RefreshCredentials extends CredentialsEvent {
  @override
  List<Object> get props => [];
}

class ClearCredentials extends CredentialsEvent {
  @override
  List<Object> get props => [];
}
