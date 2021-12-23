import 'package:bloc/bloc.dart';
import 'package:mailman/bloc/credentials/bloc.dart';
import 'package:mailman/repository/credentials_repository.dart';

class CredentialsBloc extends Bloc<CredentialsEvent, CredentialsState> {
  final CredentialsRepository credentialsRepository;

  CredentialsBloc(
      this.credentialsRepository,
      ) : super(const CredentialsState()) {
    on<RefreshCredentials>((event, emit) async {
      CredentialsState loadingState = state.copyWith(loading: true);
      emit(loadingState);

      var credentialsList = await credentialsRepository.list();

      emit(loadingState.copyWith(
        loading: false,
        fetched: true,
        credentialsList: credentialsList,
      ));
    });

    on<ClearCredentials>((event, emit) async {
      emit(state.copyWith(
        fetched: false,
        credentialsList: [],
      ));
    });
  }
}