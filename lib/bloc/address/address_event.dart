import 'package:equatable/equatable.dart';
import 'package:mailman/model/address.dart';

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

class DeleteAddress extends AddressEvent {
  final Address address;

  const DeleteAddress({
    required this.address
  });

  @override
  List<Object> get props => [
    address,
  ];
}

class SetPrimaryAddress extends AddressEvent {
  final Address address;

  const SetPrimaryAddress({
    required this.address
  });

  @override
  List<Object> get props => [
    address,
  ];
}