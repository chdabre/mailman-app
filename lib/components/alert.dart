import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Alert extends StatelessWidget {
  const Alert({
    Key? key,
    required String? errorMessage,
  }) : _errorMessage = errorMessage, super(key: key);

  final String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).errorColor,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(4))
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(AppLocalizations.of(context)!.errorWithMessage(_errorMessage ?? "")),
        ),
      ),
    );
  }
}