import 'package:equatable/equatable.dart';
import 'package:mailman/model/address.dart';
import 'package:meta/meta.dart';

@immutable
class AddressState extends Equatable {
  final bool loading;
  final bool fetched;

  final List<Address> addressList;

  const AddressState({
    this.loading = false,
    this.fetched = false,
    this.addressList = const [],
  });

  AddressState copyWith({
    bool? loading,
    bool? fetched,
    List<Address>? addressList,
  }) {
    return AddressState(
      loading: loading ?? this.loading,
      fetched: fetched ?? this.fetched,
      addressList: addressList ?? this.addressList,
    );
  }

  Address? getPrimaryAddress() {
    try {
      return addressList.firstWhere((address) => address.isPrimary);
    } on StateError catch (e) {
      return null;
    }
  }

  @override
  List<Object?> get props => [
    loading,
    fetched,
    addressList,
  ];

  @override
  String toString() => 'AddressState loading:$loading, fetched:$fetched, addresses: ${addressList.length}';
}
