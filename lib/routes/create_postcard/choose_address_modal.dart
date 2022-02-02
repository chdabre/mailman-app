import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get_it/get_it.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:mailman/bloc/address/bloc.dart';
import 'package:mailman/components/address_preview.dart';
import 'package:mailman/model/address.dart';
import 'package:mailman/routes/create_postcard/create_address_modal.dart';

final GetIt getIt = GetIt.instance;

Future<dynamic> showChooseAddressModal(BuildContext context, {
  String? titleText,
  Address? selectedAddress,
}) {
  return showCupertinoModalBottomSheet(
      context: context,
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: Text(titleText ?? AppLocalizations.of(context)!.chooseAddressTitle),
          backgroundColor: Theme.of(context).backgroundColor,
          elevation: 0,
          flexibleSpace: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: const [ Divider(height: 1) ],
          ),
          leading: Container(),
        ),
        body: ChooseAddressModalView(
          selectedAddress: selectedAddress,
        ),
      )
  );
}

class ChooseAddressModalView extends StatefulWidget {
  final Address? selectedAddress;

  const ChooseAddressModalView({
    Key? key,
    this.selectedAddress,
  }) : super(key: key);

  @override
  _ChooseAddressModalViewState createState() => _ChooseAddressModalViewState();
}

class _ChooseAddressModalViewState extends State<ChooseAddressModalView> {
  final _addressBloc = getIt<AddressBloc>();
  Address? _selectedAddress;

  @override
  void initState() {
    _addressBloc.add(RefreshAddressList());
    _selectedAddress = widget.selectedAddress;
    super.initState();
  }

  void _addressListener(BuildContext context, AddressState state) {
  }

  void _selectAddress(Address? address) {
    _selectedAddress = address;
    setState(() {});
  }

  void _createAddress(BuildContext context) async {
    _selectedAddress = await showCreateAddressModal(context);
    _addressBloc.add(RefreshAddressList());
    setState(() {});
  }

  void _deleteAddress(Address address) async {
    _addressBloc.add(DeleteAddress(address: address));
  }

  void _setPrimaryAddress(Address address) async {
    _addressBloc.add(SetPrimaryAddress(address: address));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          BlocConsumer<AddressBloc, AddressState>(
            bloc: _addressBloc,
            listener: _addressListener,
            builder: (context, addressState) {
              return Expanded(
                child: SingleChildScrollView(
                  child: SlidableAutoCloseBehavior(
                    child: Column(
                      children: [
                        if (addressState.loading) const LinearProgressIndicator(),
                        for (Address address in addressState.addressList) AddressRadioListTile(
                          key: ValueKey<int>(address.id!),
                          address: address,
                          selectedAddress: _selectedAddress,
                          onChanged: _selectAddress,
                          onDelete: () => _deleteAddress(address),
                          onSetPrimary: () => _setPrimaryAddress(address),
                        ),
                        const Divider(),
                        ListTile(
                          leading: const Icon(Icons.add),
                          title: Text(AppLocalizations.of(context)!.createAddressButton),
                          onTap: () => _createAddress(context),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
                onPressed: _selectedAddress != null ? () => Navigator.pop(context, _selectedAddress) : null,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                  elevation: 0,
                ),
                child: Text(AppLocalizations.of(context)!.confirmAddressButton.toUpperCase())
            ),
          ),
        ],
      ),
    );
  }
}

class AddressRadioListTile extends StatelessWidget {
  const AddressRadioListTile({
    required Key key,
    required this.address,
    this.selectedAddress,
    this.onChanged,
    this.onDelete,
    this.onSetPrimary,
  }) : super(key: key);

  final Address address;
  final Address? selectedAddress;
  final Function(Address? newValue)? onChanged;
  final void Function()? onDelete;
  final void Function()? onSetPrimary;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: key,
      groupTag: '0',
      endActionPane: address.isPrimary ? null : ActionPane(
        motion: const ScrollMotion(),
        dismissible: DismissiblePane(onDismissed: () { onDelete?.call(); }),
        children: [
          if (!address.isPrimary) SlidableAction(
            onPressed: (_) { onSetPrimary?.call(); },
            icon: Icons.home,
            backgroundColor: Theme.of(context).disabledColor,
          ),
          if (!address.isPrimary) SlidableAction(
            onPressed: (_) { onDelete?.call(); },
            icon: Icons.delete,
            backgroundColor: Theme.of(context).colorScheme.error,
          )
        ],
      ),
      child: RadioListTile(
          value: address,
          groupValue: selectedAddress,
          onChanged: onChanged,
          activeColor: Theme.of(context).primaryColor,
          contentPadding: const EdgeInsets.only(left: 8.0, right: 16.0, top: 4.0, bottom: 4.0),
          title: Row(
            children: [
              AddressPreview(
                address: address,
                color: Colors.transparent,
              ),
            ],
          )
      ),
    );
  }
}
