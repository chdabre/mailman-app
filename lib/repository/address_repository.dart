import 'package:mailman/model/address.dart';

abstract class AddressRepository {
  Future<List<Address>> list();

  Future<Address?> get({ required int id });

  Future<Address?> create(Address address);
}

