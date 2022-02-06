import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final termsOptions = ChromeSafariBrowserClassOptions(
  android: AndroidChromeCustomTabsOptions(
    enableUrlBarHiding: true,
    addDefaultShareMenuItem: false,
  ),
  ios: IOSSafariOptions(
    presentationStyle: IOSUIModalPresentationStyle.POPOVER,
  ),
);

class TermsListTile extends StatefulWidget {
  const TermsListTile({Key? key}) : super(key: key);

  @override
  _TermsListTileState createState() => _TermsListTileState();
}

class _TermsListTileState extends State<TermsListTile> {
  final _browser = ChromeSafariBrowser();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        _browser.open(
          url: Uri.parse(AppLocalizations.of(context)!.termsUrl),
          options: termsOptions,
        );
      },
      leading: Icon(Icons.info_outline),
      title: Text(AppLocalizations.of(context)!.termsLabel),
    );
  }
}


class TermsButton extends StatefulWidget {
  const TermsButton({Key? key,}) : super(key: key);
  @override
  State<TermsButton> createState() => _TermsButtonState();
}

class _TermsButtonState extends State<TermsButton> {
  final _browser = ChromeSafariBrowser();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _browser.open(
          url: Uri.parse(AppLocalizations.of(context)!.termsUrl),
          options: termsOptions,
        );
      },
      child: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Icon(Icons.info_outline),
      ),
    );
  }
}