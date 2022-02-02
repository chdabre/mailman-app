import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mailman/components/icon_and_text_label.dart';

class MessagePreview extends StatelessWidget {
  const MessagePreview({
    Key? key,
    this.message,
    this.messageImageUrl,
    this.messageImage,
    this.onTap,
    this.compact = false,
    this.actionLabel = "",
  }) : super(key: key);

  final bool compact;
  final String? message;
  final File? messageImage;
  final String? messageImageUrl;
  final String actionLabel;
  final void Function()? onTap;

  final double _messagePreviewBorderRadius = 3;

  ImageProvider? _getMessageImage() {
    if (messageImage != null) {
      return FileImage(messageImage!);
    }
    else if (messageImageUrl != null) {
      return CachedNetworkImageProvider(messageImageUrl!);
    }
  }

  Widget _buildTextPreview(BuildContext context) {
    if (message == null && _getMessageImage() == null) {
      return IconAndTextLabel(icon: Icons.edit, actionLabel: actionLabel);
    }
    if (message != null && _getMessageImage() == null) {
      return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!compact) ...[
                  Text(actionLabel.toUpperCase(),
                      style: Theme
                          .of(context)
                          .textTheme
                          .button!
                          .copyWith(
                        fontSize: 10,
                      )
                  ),
                  const SizedBox(height: 4,),
                ],
                Text(
                  message!,
                  style: Theme
                      .of(context)
                      .textTheme
                      .caption!
                      .copyWith(
                    color: Theme
                        .of(context)
                        .colorScheme
                        .onSurface,
                    fontSize: compact ? 10 : 14,
                  ),
                  softWrap: true,
                )
              ],
            ),
          ));
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 720 / 744,
      child: Material(
        borderRadius: BorderRadius.circular(_messagePreviewBorderRadius),
        child: InkWell(
            onTap: onTap,
            child: Container(
                decoration: _getMessageImage() != null ?
                BoxDecoration(
                    borderRadius: BorderRadius.circular(_messagePreviewBorderRadius),
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: _getMessageImage()!,
                    )) :
                  BoxDecoration(
                    borderRadius:
                    BorderRadius.circular(_messagePreviewBorderRadius),
                    border: Border.all(color: Theme.of(context).dividerColor)),
                child: _buildTextPreview(context),
            )
        ),
      ),
    );
  }
}