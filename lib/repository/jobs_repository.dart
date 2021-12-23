import 'package:mailman/model/postcard.dart';

abstract class JobsRepository {
  Future<List<Postcard>> list();

  Future<Postcard?> get({
    required int id,
  });

  Future<Postcard?> create(Postcard postcard);

  Future<void> delete(Postcard postcard);
}

