import 'package:cached_network_image/cached_network_image.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mailman/components/icon_and_text_label.dart';
import 'package:mailman/components/material_postcard.dart';
import 'package:mailman/model/postcard.dart';

class PostcardPreview extends StatefulWidget {
  final Postcard postcard;
  final void Function()? onPickFrontImage;
  final void Function()? onEditMessage;
  final void Function()? onEditSenderAddress;
  final void Function()? onEditRecipientAddress;
  final bool loading;
  final bool editable;

  const PostcardPreview({
    Key? key,
    required this.postcard,
    this.onPickFrontImage,
    this.onEditMessage,
    this.onEditSenderAddress,
    this.onEditRecipientAddress,
    this.loading = false,
    this.editable = false,
  }) : super(key: key);

  @override
  State<PostcardPreview> createState() => PostcardPreviewState();
}

class PostcardPreviewState extends State<PostcardPreview> {
  final _cardController = FlipCardController();

  bool flipToSide({bool showFront = false}) {
    var isFront = _cardController.state!.isFront;
    if (isFront != showFront) {
      _cardController.toggleCard();
      return true;
    }
    return false;
  }

  ImageProvider? _getbackgroundImage() {
    if (widget.postcard.frontImage != null) return FileImage(widget.postcard.frontImage!);
    if (widget.postcard.frontImageUrl != null) return CachedNetworkImageProvider(widget.postcard.frontImageUrl!);
  }

  Widget _buildFront() {
    var postcard = widget.postcard;
    if (widget.editable && !postcard.hasFrontImage()) {
      return MaterialPostcard(
          onTap: widget.onPickFrontImage,
          loading: widget.loading,
          child: IconAndTextLabel(
            icon: Icons.image,
            actionLabel: AppLocalizations.of(context)!.postcardImagePlaceholder,
            fontSize: 12,
          ));
    }
    return MaterialPostcard(
      onTap: widget.onPickFrontImage,
      isLandscape: postcard.isLandscape,
      backgroundImage: _getbackgroundImage(),
      child: Container(),
    );
  }

  Widget _buildBack() {
    return MaterialPostcardBack(
      postcard: widget.postcard,
      onEditMessage: widget.onEditMessage,
      onEditRecipientAddress: widget.onEditRecipientAddress,
      onEditSenderAddress: widget.onEditSenderAddress,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FlipCard(
          controller: _cardController,
          flipOnTouch: !widget.editable,
          front: _buildFront(),
          back: _buildBack(),
        ),
        const SizedBox(
          height: 8,
        ),
        if (widget.editable) IconButton(
            splashRadius: 16,
            onPressed: () => _cardController.toggleCard(),
            icon: const Icon(Icons.flip_camera_android))
      ],
    );
  }
}