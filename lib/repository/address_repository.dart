import 'package:mailman/model/address.dart';

abstract class AddressRepository {
  Future<List<Address>> list();

  Future<Address?> get({ required int id });

  Future<Address?> setPrimary({ required Address address });

  Future<Address?> create({ required Address address});

  Future<void> delete({ required Address address});
}

