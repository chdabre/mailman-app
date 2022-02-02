import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mailman/bloc/address/bloc.dart';
import 'package:mailman/components/alert.dart';
import 'package:mailman/model/address.dart';
import 'package:mailman/repository/address_repository.dart';
import 'package:mailman/repository/rest/api_client.dart';
import 'package:mailman/utils/validation.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

final GetIt getIt = GetIt.instance;

Future<dynamic> showCreateAddressModal(BuildContext context) {
  return showCupertinoModalBottomSheet(
      context: context,
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.createAddressTitle),
          backgroundColor: Theme.of(context).backgroundColor,
          elevation: 0,
          flexibleSpace: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: const [ Divider(height: 1) ],
          ),
          leading: Container(),
        ),
        body: const CreateAddressModalView(),
      )
  );
}

class CreateAddressModalView extends StatefulWidget {
  const CreateAddressModalView({Key? key}) : super(key: key);

  @override
  _CreateAddressModalViewState createState() => _CreateAddressModalViewState();
}

class _CreateAddressModalViewState extends State<CreateAddressModalView> {
  final addressRepository = getIt<AddressRepository>();
  final _formKey = GlobalKey<FormState>();

  bool _hasError = false;
  final String? _errorMessage = "";

  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _streetController;
  late TextEditingController _cityController;
  late TextEditingController _postCodeController;

  final FocusScopeNode _scopeNode = FocusScopeNode();

  void _addressListener(BuildContext context, AddressState state) {
  }

  void _formInputChanged() {
    _formKey.currentState?.validate();
  }

  void _submitButtonPressed() async {
    if (_formKey.currentState!.validate()) {
      _hasError = false;
      var address = Address(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        street: _streetController.text,
        city: _cityController.text,
        zipCode: _postCodeController.text,
      );

      try {
        var created = await addressRepository.create(address: address);
        Navigator.pop(context, created);
      } on IOError {
        // TODO Error handling
      }
    }
    setState(() {});
  }

  @override
  void initState() {
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _streetController = TextEditingController();
    _cityController = TextEditingController();
    _postCodeController = TextEditingController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddressBloc, AddressState>(
      bloc: getIt<AddressBloc>(),
      listener: _addressListener,
      builder: (_, addressState) {
        return SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: FocusScope(
                      node: _scopeNode,
                      autofocus: true,
                      child: Form(
                        key: _formKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        onChanged: _formInputChanged,
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Flexible(
                                  child: TextFormField(
                                    controller: _firstNameController,
                                    validator: nonEmptyStringValidator(context),
                                    autofocus: true,
                                    keyboardType: TextInputType.name,
                                    textInputAction: TextInputAction.next,
                                    onEditingComplete: _scopeNode.nextFocus,
                                    decoration: InputDecoration(
                                      label: Text(AppLocalizations.of(context)!.formFieldFirstName),
                                      border: const OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8.0,),
                                Flexible(
                                  child: TextFormField(
                                    controller: _lastNameController,
                                    validator: nonEmptyStringValidator(context),
                                    keyboardType: TextInputType.name,
                                    textInputAction: TextInputAction.next,
                                    onEditingComplete: _scopeNode.nextFocus,
                                    decoration: InputDecoration(
                                      label: Text(AppLocalizations.of(context)!.formFieldLastName),
                                      border: const OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16.0,),
                            TextFormField(
                              controller: _streetController,
                              validator: nonEmptyStringValidator(context),
                              keyboardType: TextInputType.streetAddress,
                              textInputAction: TextInputAction.next,
                              onEditingComplete: _scopeNode.nextFocus,
                              decoration: InputDecoration(
                                label: Text(AppLocalizations.of(context)!.formFieldAddress),
                                border: const OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 16.0,),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 72,
                                  child: TextFormField(
                                    controller: _postCodeController,
                                    validator: nonEmptyStringValidator(context),
                                    keyboardType: TextInputType.number,
                                    textInputAction: TextInputAction.next,
                                    onEditingComplete: _scopeNode.nextFocus,
                                    decoration: InputDecoration(
                                      label: Text(AppLocalizations.of(context)!.formFieldZipCode),
                                      border: const OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8.0,),
                                Flexible(
                                  child: TextFormField(
                                    controller: _cityController,
                                    validator: nonEmptyStringValidator(context),
                                    keyboardType: TextInputType.streetAddress,
                                    textInputAction: TextInputAction.done,
                                    onEditingComplete: _submitButtonPressed,
                                    decoration: InputDecoration(
                                      label: Text(AppLocalizations.of(context)!.formFieldCity),
                                      border: const OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16.0,),
                            if (_hasError) ...[
                              Alert(errorMessage: _errorMessage),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const Divider(height: 1,),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(40),
                    ),
                    onPressed: _submitButtonPressed,
                    child: Text(AppLocalizations.of(context)!.saveAddressButton.toUpperCase())
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
