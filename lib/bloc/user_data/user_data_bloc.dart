import 'package:bloc/bloc.dart';
import 'package:mailman/bloc/user_data/bloc.dart';
import 'package:mailman/repository/rest/api_client.dart';
import 'package:mailman/repository/user_repository.dart';

class UserDataBloc extends Bloc<UserDataEvent, UserDataState> {
  final UserRepository userRepository;

  UserDataBloc(
      this.userRepository,
  ) : super(const UserDataState()) {
    on<RefreshUserData>((event, emit) async {
      UserDataState loadingState = state.copyWith(loading: true);
      emit(loadingState);

      try {
        var user = await userRepository.getUser();

        emit(loadingState.copyWith(
          loading: false,
          fetched: true,
          user: user,
        ));
      } on IOError {
        emit(loadingState.copyWith(
          loading: false,
          fetched: false,
        ));
      }
    });

    on<ClearUserData>((event, emit) async {
      emit(state.copyWith(
        fetched: false,
        user: null,
      ));
    });
  }
}