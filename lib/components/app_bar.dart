import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mailman/routes/preferences_modal.dart';

class ShowPreferencesAction extends StatelessWidget {
  const ShowPreferencesAction({Key? key}) : super(key: key);

  void _onActionButtonPressed(BuildContext context) {
    var preferencesModal = PreferencesModal.instance;
    preferencesModal.showPreferencesModal(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () => _onActionButtonPressed(context),
        splashRadius: 24,
        icon: const Icon(Icons.menu)
    );
  }
}


class MailmanAppBar {
  static buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).backgroundColor,
      elevation: 0,
      flexibleSpace: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: const [ Divider(height: 1) ],
      ),
      title: Text(AppLocalizations.of(context)!.appTitle.toLowerCase(),
        style: Theme.of(context).textTheme.headline4,
      ),
      actions: const [
        ShowPreferencesAction(),
      ],
    );
  }
}