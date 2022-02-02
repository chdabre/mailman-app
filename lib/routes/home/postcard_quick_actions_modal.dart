import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mailman/components/postcard_preview.dart';
import 'package:mailman/model/postcard.dart';
import 'package:mailman/repository/jobs_repository.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

final GetIt getIt = GetIt.instance;

Future<dynamic> showQuickActionsModal(BuildContext context, Postcard postcard) {
  return showCupertinoModalBottomSheet(
      context: context,
      builder: (context) => Material(
          child: QuickActionsModalView(postcard: postcard)
      )
  );
}

class QuickActionsModalView extends StatefulWidget {
  const QuickActionsModalView({
    Key? key,
    required this.postcard,
  }) : super(key: key);

  final Postcard postcard;

  @override
  _QuickActionsModalViewState createState() => _QuickActionsModalViewState();
}

class _QuickActionsModalViewState extends State<QuickActionsModalView> {
  final _jobsRepository = getIt<JobsRepository>();

  void _deletePostcard() async {
    await _jobsRepository.delete(widget.postcard);
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 24.0, bottom: 36.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PostcardPreview(postcard: widget.postcard),
            const Divider(),
            ListTile(
              onTap: _deletePostcard,
              leading: const Icon(Icons.delete),
              title: Text(AppLocalizations.of(context)!.jobActionDelete),
            ),
          ],
        ),
      ),
    );
  }
}