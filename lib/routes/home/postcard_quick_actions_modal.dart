import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
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
              title: const Text("Delete"),
            )
          ],
        ),
      ),
    );
  }
}



class EditMessageModalView extends StatefulWidget {
  final String? message;

  const EditMessageModalView({
    Key? key,
    this.message,
  }) : super(key: key);

  @override
  _EditMessageModalViewState createState() => _EditMessageModalViewState();
}

class _EditMessageModalViewState extends State<EditMessageModalView> {
  final _textController = TextEditingController();

  @override
  void initState() {
    if (widget.message != null) _textController.text = widget.message!;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: TextField(
                controller: _textController,
                keyboardType: TextInputType.multiline,
                autofocus: true,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 16,),
            ElevatedButton(
                onPressed: () => Navigator.pop(context, _textController.text),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                  elevation: 0,
                ),
                child: Text("Confirm".toUpperCase())
            ),
          ],
        ),
      ),
    );
  }
}
