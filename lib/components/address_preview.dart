import 'package:flutter/material.dart';
import 'package:mailman/components/icon_and_text_label.dart';
import 'package:mailman/model/address.dart';

class AddressPreview extends StatelessWidget {
  final Address? address;
  final String actionLabel;
  final bool compact;
  final Color? color;
  final void Function()? onTap;

  final double _addressPreviewBorderRadius = 3;

  const AddressPreview({
    Key? key,
    this.address,
    this.actionLabel = "",
    this.compact = false,
    this.color,
    this.onTap,
  }) : super(key: key);

  Widget _buildAddressLine(BuildContext context, String text) {
    return Text(
      text,
      style: Theme.of(context).textTheme.caption!.copyWith(
        color: Theme.of(context).colorScheme.onSurface,
        fontSize: compact ? 10 : 14,
      ),
      overflow: TextOverflow.fade,
      softWrap: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: color,
        borderRadius: BorderRadius.circular(_addressPreviewBorderRadius),
        child: InkWell(
            onTap: onTap,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius:
                  BorderRadius.circular(_addressPreviewBorderRadius),
                  border: Border.all(color: Theme.of(context).dividerColor)),
              child: address != null
                  ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!compact && actionLabel.isNotEmpty) ...[
                      Text(actionLabel.toUpperCase(),
                          style: Theme.of(context).textTheme.button!.copyWith(
                            fontSize: 10,
                          )
                      ),
                      const SizedBox(height: 4,),
                    ],
                    _buildAddressLine(context,
                        "${address!.firstName} ${address!.lastName}"),
                    _buildAddressLine(context, address!.street),
                    _buildAddressLine(
                        context, "${address!.zipCode} ${address!.city}"),
                  ],
                ),
              )
                  : IconAndTextLabel(
                actionLabel: actionLabel,
                icon: Icons.contact_mail,
              ),
            )),
      ),
    );
  }
}