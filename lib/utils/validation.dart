import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

String? _validateEmail(BuildContext context, String? value) {
  String pattern =
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
      r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
      r"{0,253}[a-zA-Z0-9])?)*$";
  RegExp regex = RegExp(pattern);
  if (value == null || value.isEmpty || !regex.hasMatch(value)) {
    return AppLocalizations.of(context)!.validationEmailInvalid;
  } else {
    return null;
  }
}

String? _validateNonEmptyString(BuildContext context, String? value) {
  if (value == null || value.isEmpty) {
    return AppLocalizations.of(context)!.validationNonEmptyString;
  }
  return null;
}

String? Function(String?) emailValidator(BuildContext context) => (value) => _validateEmail(context, value);
String? Function(String?) nonEmptyStringValidator(BuildContext context) => (value) => _validateNonEmptyString(context, value);