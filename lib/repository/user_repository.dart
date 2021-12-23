import 'package:mailman/entity/user_entity.dart';
import 'package:mailman/model/user.dart';

abstract class UserRepository {
  Future<void> init();

  Future<User?> getUser();

  Future<User?> updateUser(UserEntity userEntity);
}

