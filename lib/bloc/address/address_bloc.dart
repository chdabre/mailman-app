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

    on<DeleteAddress>((event, emit) async {
      final obj = event.address;
      var tempList = state.addressList.where((a) => a.id != obj.id).toList();

      AddressState loadingState = state.copyWith(
        loading: true,
        addressList: tempList,
      );
      emit(loadingState);

      await addressRepository.delete(address: obj);
      var addressList = await addressRepository.list();

      emit(loadingState.copyWith(
        loading: false,
        fetched: true,
        addressList: addressList,
      ));
    });

    on<SetPrimaryAddress>((event, emit) async {
      final obj = event.address;

      AddressState loadingState = state.copyWith(
        loading: true,
      );
      emit(loadingState);

      await addressRepository.setPrimary(address: obj);
      var addressList = await addressRepository.list();

      emit(loadingState.copyWith(
        loading: false,
        fetched: true,
        addressList: addressList,
      ));
    });
  }
}