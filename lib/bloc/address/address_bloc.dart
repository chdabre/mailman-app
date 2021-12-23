import 'package:bloc/bloc.dart';
import 'package:mailman/bloc/address/bloc.dart';
import 'package:mailman/repository/address_repository.dart';

class AddressBloc extends Bloc<AddressEvent, AddressState> {
  final AddressRepository addressRepository;

  AddressBloc(
      this.addressRepository,
      ) : super(const AddressState()) {
    on<RefreshAddressList>((event, emit) async {
      AddressState loadingState = state.copyWith(loading: true);
      emit(loadingState);

      var addressList = await addressRepository.list();

      emit(loadingState.copyWith(
        loading: false,
        fetched: true,
        addressList: addressList,
      ));
    });

    on<ClearAddressList>((event, emit) async {
      emit(state.copyWith(
        fetched: false,
        addressList: null,
      ));
    });
  }
}