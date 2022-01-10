import 'package:flutter/material.dart';
import 'package:mailman/components/address_preview.dart';
import 'package:mailman/components/message_preview.dart';
import 'package:mailman/model/postcard.dart';

class MaterialPostcard extends StatelessWidget {
  final Widget child;
  final bool isLandscape;
  final double maxWidth;
  final double maxHeight;
  final bool loading;
  final Color? color;
  final ImageProvider? backgroundImage;
  final void Function()? onTap;

  final double _postcardBorderRadius = 4;

  static const double _postcardAspectRatioLandscape = 3 / 2;
  static const double _postcardAspectRatioPortrait = 2 / 3;

  const MaterialPostcard({
    Key? key,
    required this.child,
    this.isLandscape = true,
    this.maxWidth = 300,
    this.maxHeight = 300,
    this.loading = false,
    this.color,
    this.backgroundImage,
    this.onTap,
  }) : super(key: key);

  double _getWidth() {
    if (isLandscape) return maxWidth;
    return maxHeight * _postcardAspectRatioPortrait;
  }

  double _getHeight() {
    if (isLandscape) return maxWidth / _postcardAspectRatioLandscape;
    return maxHeight;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(_postcardBorderRadius),
      color: Color.alphaBlend(
          color ?? Colors.grey.shade100, Theme.of(context).backgroundColor),
      child: Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            foregroundDecoration: BoxDecoration(
                color: Colors.black.withOpacity(loading ? 0.5 : 0),
                borderRadius: BorderRadius.circular(_postcardBorderRadius)),
            decoration: backgroundImage != null
                ? BoxDecoration(
                borderRadius: BorderRadius.circular(_postcardBorderRadius),
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: backgroundImage!,
                ))
                : const BoxDecoration(),
            alignment: Alignment.center,
            width: _getWidth(),
            height: _getHeight(),
          ),
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(_postcardBorderRadius),
              child: InkWell(
                onTap: !loading ? onTap : null,
                child: child,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MaterialPostcardBack extends StatelessWidget {
  const MaterialPostcardBack({
    Key? key,
    this.postcard,
    this.onEditMessage,
    this.onEditSenderAddress,
    this.onEditRecipientAddress,
  }) : super(key: key);

  final Postcard? postcard;
  final void Function()? onEditMessage;
  final void Function()? onEditSenderAddress;
  final void Function()? onEditRecipientAddress;

  final double _backElementBorderRadius = 3;

  Widget _buildStamp(BuildContext context) {
    return SizedBox(
      height: 28,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          AspectRatio(
              aspectRatio: 4 / 3,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(_backElementBorderRadius),
                ),
              ))
        ],
      ),
    );
  }

  Widget _buildAdPlaceholder(BuildContext context) {
    return Expanded(
        child: Container(
          decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,
              borderRadius: BorderRadius.circular(_backElementBorderRadius),
              border: Border.all(color: Theme.of(context).dividerColor)),
          child: Center(
            child: Text(
              "Advertisement",
              style: Theme.of(context).textTheme.caption,
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialPostcard(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    MessagePreview(
                      onTap: onEditMessage,
                      message: postcard?.message,
                      messageImageUrl: postcard?.messageImageUrl,
                      messageImage: postcard?.messageImage,
                      compact: true,
                      actionLabel: "Message",
                    ),
                    const SizedBox(height: 8),
                    _buildAdPlaceholder(context),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                  child: Column(
                    children: [
                      _buildStamp(context),
                      const SizedBox(height: 4),
                      AddressPreview(
                        address: postcard?.sender,
                        onTap: onEditSenderAddress,
                        actionLabel: "Sender",
                        compact: true,
                      ),
                      const SizedBox(height: 8),
                      AddressPreview(
                        address: postcard?.recipient,
                        onTap: onEditRecipientAddress,
                        actionLabel: "Recipient",
                        compact: true,
                      ),
                    ],
                  )),
            ],
          ),
        ));
  }
}