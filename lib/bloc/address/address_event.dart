import 'package:equatable/equatable.dart';

abstract class AddressEvent extends Equatable {
  const AddressEvent();
}

class RefreshAddressList extends AddressEvent {
  @override
  List<Object> get props => [];
}

class ClearAddressList extends AddressEvent {
  @override
  List<Object> get props => [];
}
