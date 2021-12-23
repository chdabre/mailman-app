import 'package:mailman/model/authentication_result.dart';

abstract class AuthRepository {
  Future<void> init();

  Future<AuthenticationResult?> register({
    required String username,
    String email,
    required String password1,
    required String password2,
  });

  Future<AuthenticationResult?> login({
    required String username,
    required String password,
  });

  Future<void> logout();

  Future<bool> hasToken();

  Future<String?> getToken();

  Future<void> persistToken(String token);

  Future<void> deleteToken();
}

