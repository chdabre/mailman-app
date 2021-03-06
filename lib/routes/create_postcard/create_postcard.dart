import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mailman/bloc/address/bloc.dart';
import 'package:mailman/components/postcard_preview.dart';
import 'package:mailman/components/terms_button.dart';
import 'package:mailman/image_utils.dart';
import 'package:mailman/model/postcard.dart';
import 'package:mailman/model/rich_message_data.dart';
import 'package:mailman/repository/jobs_repository.dart';
import 'package:mailman/repository/rest/api_client.dart';
import 'package:mailman/routes/create_postcard/choose_address_modal.dart';

import 'edit_rich_message_modal.dart';

final GetIt getIt = GetIt.instance;

class CreatePostcardRoute extends StatefulWidget {
  static const routeName = '/create';

  const CreatePostcardRoute({
    Key? key,
  }) : super(key: key);

  @override
  _CreatePostcardRouteState createState() => _CreatePostcardRouteState();
}

class _CreatePostcardRouteState extends State<CreatePostcardRoute> {
  late Postcard _postcard;

  final GlobalKey<PostcardPreviewState> _preview = GlobalKey();
  bool _didAcceptTerms = false;
  bool _postcardLoading = false;
  bool _loading = false;

  @override
  void initState() {
    var addressBloc = getIt<AddressBloc>();
    _postcard = Postcard(
      sender: addressBloc.state.getPrimaryAddress(),
    );
    super.initState();
  }

  @override
  void didChangeDependencies() {
    final postcard = ModalRoute.of(context)!.settings.arguments as Postcard?;
    if(postcard?.id != null) {
      _postcard = postcard!;
      setState(() {});
    }
    super.didChangeDependencies();
  }

  void _pickFrontImage() async {
    _postcardLoading = true;
    setState(() {});
    final ImagePicker _picker = ImagePicker();
    var pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      bool isLandscape = await ImageUtils.imageIsLandscape(await pickedImage.readAsBytes());
      double aspectRatio = pow(3 / 2, isLandscape ? 1 : -1).toDouble();

      var croppedImage = await ImageCropper.cropImage(
        sourcePath: pickedImage.path,
        aspectRatio: CropAspectRatio(ratioX: aspectRatio, ratioY: 1),
        iosUiSettings: const IOSUiSettings(
          rotateButtonsHidden: true,
        ),
        androidUiSettings: AndroidUiSettings(
          toolbarWidgetColor: Theme.of(context).colorScheme.onSurface,
          activeControlsWidgetColor: Theme.of(context).primaryColor,
          toolbarColor: Theme.of(context).backgroundColor,
          statusBarColor: Theme.of(context).backgroundColor,
          backgroundColor: Theme.of(context).backgroundColor,
          cropFrameColor: Theme.of(context).backgroundColor,
        ),
      );

      if (croppedImage != null) {
        var resizedImage = await ImageUtils.resizeImageMaintainOrientation(
          croppedImage,
          width: 1819,
          height: 1311,
          isLandscape: isLandscape,
          rotate: true,
        );

        _postcard = _postcard.copyWith(
          frontImage: resizedImage,
          isLandscape: isLandscape,
        );
      }
    }

    _postcardLoading = false;
    if (_postcard.hasFrontImage()) {
      Timer(const Duration(milliseconds: 300),
        () => _preview.currentState?.flipToSide(showFront: false),
      );
    }
    setState(() {});
  }

  void _editMessage(BuildContext context) async {
    var messageData = _postcard.messageData ?? RichMessageData.empty.copyWith(
      message: _postcard.message ?? '',
    );

    RichMessageEditResult? newMessage = await showEditRichMessageModal(context, messageData);

    if (newMessage != null) {
      _postcard = _postcard.copyWith(
        message: newMessage.messageData.message,
        messageData: newMessage.messageData,
        messageImage: newMessage.textImage,
      );
      setState(() {});
    }
  }

  void _pickSenderAddress(BuildContext context) async {
    var address = await showChooseAddressModal(context,
        selectedAddress: _postcard.sender,
        titleText: AppLocalizations.of(context)!.senderAddressModalTitle,
    );
    _postcard = _postcard.copyWith(
      sender: address,
    );
    setState(() {});
  }

  void _pickRecipientAddress(BuildContext context) async {
    var address = await showChooseAddressModal(context,
        selectedAddress: _postcard.recipient,
        titleText: AppLocalizations.of(context)!.recipientAddressModalTitle,
    );
    _postcard = _postcard.copyWith(
      recipient: address,
    );
    setState(() {});
  }

  bool _valid() {
    return _postcard.isValid() && _didAcceptTerms && !_loading;
  }

  void _submit(BuildContext context) async {
    _loading = true;
    setState(() {});
    var jobsRepository = getIt<JobsRepository>();
    try {
      Postcard? result;
      print(_postcard);
      if (_postcard.id != null) {
        result = await jobsRepository.update(_postcard);
      } else {
        result = await jobsRepository.create(_postcard);
      }
      Navigator.pop(context, result);
    } on IOError {
      // TODO Error handling
    } finally {
      _loading = false;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        elevation: 0,
        title: Text(AppLocalizations.of(context)!.createModalTitle),
        flexibleSpace: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: const [
            Divider(
              height: 1,
            )
          ],
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 24),
                      child: Center(
                          child: PostcardPreview(
                            key: _preview,
                            editable: true,
                            postcard: _postcard,
                            loading: _postcardLoading,
                            onPickFrontImage: _pickFrontImage,
                            onEditMessage: () => _editMessage(context),
                            onEditSenderAddress: () => _pickSenderAddress(context),
                            onEditRecipientAddress: () => _pickRecipientAddress(context),
                      )),
                    ),
                    const Divider(height: 1,),
                  ],
                ),
              ),
            ),
            IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(
                    child: CheckboxListTile(
                      title: Text(AppLocalizations.of(context)!.createTermsLabel,
                          style: Theme.of(context).textTheme.caption,
                      ),
                      activeColor: Theme.of(context).primaryColor,
                      controlAffinity: ListTileControlAffinity.leading,
                      value: _didAcceptTerms,
                      onChanged: (value) {
                        _didAcceptTerms = value ?? false;
                        setState(() {});
                      }
                    ),
                  ),
                  const VerticalDivider(width: 0, indent: 4, endIndent: 4,),
                  const TermsButton()
                ],
              ),
            ),
            const Divider(height: 1,),
            if (_loading) const LinearProgressIndicator(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: ElevatedButton(
                onPressed: _valid() ? () => _submit(context) : null,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                  elevation: 0,
                ),
                child: Text(AppLocalizations.of(context)!.submitPostcardButton.toUpperCase())
              ),
            ),
          ],
        ),
      ),
    );
  }
}