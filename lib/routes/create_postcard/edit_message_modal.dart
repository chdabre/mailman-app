import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

Future<dynamic> showEditMessageModal(BuildContext context, String? message) {
  return showCupertinoModalBottomSheet(
      context: context,
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: const Text("Edit Message"),
          backgroundColor: Theme.of(context).backgroundColor,
          elevation: 0,
          flexibleSpace: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: const [ Divider(height: 1) ],
          ),
          leading: Container(),
        ),
        body: EditMessageModalView(message: message,),
      )
  );
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
