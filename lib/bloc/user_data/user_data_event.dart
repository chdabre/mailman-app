import 'package:equatable/equatable.dart';

abstract class UserDataEvent extends Equatable {
  const UserDataEvent();
}

class RefreshUserData extends UserDataEvent {
  @override
  List<Object> get props => [];
}

class ClearUserData extends UserDataEvent {
  @override
  List<Object> get props => [];
}
