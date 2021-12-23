import 'package:mailman/model/credentials.dart';

abstract class CredentialsRepository {
  Future<void> init();

  Future<List<Credentials>> list();

  Future<Credentials?> get(int id);

  Future<Credentials?> create(Credentials credentials);
}

