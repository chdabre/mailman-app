
import 'package:bloc/bloc.dart';
import 'package:mailman/bloc/auth/auth_event.dart';
import 'package:mailman/bloc/auth/auth_state.dart';
import 'package:mailman/repository/auth_repository.dart';
import 'package:mailman/repository/rest/api_client.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthRepository authRepository;

  AuthenticationBloc({
    required this.authRepository,
  }) : super(Uninitialized()) {
    // Recover auth state on app open
    on<AppStarted>((event, emit) async {
      bool authenticated = false;
      bool hasToken = await authRepository.hasToken();

      if (hasToken) {
        authenticated = true;
      }

      emit(authenticated ? Authenticated(): Unauthenticated());
    });

    on<Login>((event, emit) async {
      emit(LoggingIn());
      try {
        var authResult = await authRepository.login(username: event.username, password: event.password);

        if (authResult != null) {
          emit(LoginResult(success: true));
          await authRepository.persistToken(authResult.token);
          emit(Authenticated());
        }
      } on IOError catch (e) {
        var errorMessage = "Unknown Error";
        if (e.data != null) {
          if (e.data!.containsKey('non_field_errors')) {
            errorMessage = List<dynamic>.from(e.data!['non_field_errors']).join("\n");
          }
        }
        emit(LoginResult(
          success: false,
          errorMessage: errorMessage,
        ));
        emit(Unauthenticated());
    }
    });

    on<SignUp>((event, emit) async {
      emit(LoggingIn());
      try {
        var authResult = await authRepository.register(
            username: event.email,
            email: event.email,
            password1: event.password,
            password2: event.password,
        );

        if (authResult != null) {
          emit(LoginResult(success: true));
          await authRepository.persistToken(authResult.token);
          emit(Authenticated());
        }
      } on IOError catch (e) {
        var errorMessage = "Unknown Error";
        if (e.data != null) {
          if (e.data!.containsKey('non_field_errors')) {
            errorMessage = List<dynamic>.from(e.data!['non_field_errors']).join("\n");
          }
          errorMessage = e.data!.entries.map((entry) => "${entry.key}: ${entry.value}").join("\n");
        }
        emit(LoginResult(
          success: false,
          errorMessage: errorMessage,
        ));
        emit(Unauthenticated());
      }
    });

    on<Logout>((event, emit) async {
      try {
        await authRepository.logout();
      } on IOError catch (e) {
        // TODO Handle error
      } finally {
        emit(Unauthenticated());
      }
    });
  }
}