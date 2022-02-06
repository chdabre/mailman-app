import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
          options: ChromeSafariBrowserClassOptions(
            android: AndroidChromeCustomTabsOptions(
              enableUrlBarHiding: true,
              addDefaultShareMenuItem: false,
            ),
            ios: IOSSafariOptions(
              presentationStyle: IOSUIModalPresentationStyle.POPOVER,
            ),
          ),
        );
      },
      child: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Icon(Icons.info_outline),
      ),
    );
  }
}