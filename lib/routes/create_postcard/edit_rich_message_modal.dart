import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:vector_math/vector_math_64.dart' as vector_math_64;
import 'package:matrix_gesture_detector/matrix_gesture_detector.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

Future<dynamic> showEditRichMessageModal(BuildContext context, String? message) {
  return showCupertinoModalBottomSheet(
      context: context,
      //enableDrag: false,
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
        resizeToAvoidBottomInset : false,
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
            const AspectRatio(
              aspectRatio: 720 / 744,
              child: RichMessageEditor()
            ),
            const Spacer(),
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

class RichMessageTextObject {
  Matrix4? initialPosition;

  RichMessageTextObject({
    this.initialPosition,
  }) {
    initialPosition ??= Matrix4.identity();
  }

  var textStyle = const TextStyle(
    fontSize: 40,
  );

  var text = "";
}

class RichMessageEditor extends StatefulWidget {
  const RichMessageEditor({Key? key}) : super(key: key);

  @override
  _RichMessageEditorState createState() => _RichMessageEditorState();
}

class _RichMessageEditorState extends State<RichMessageEditor> {
  final List<RichMessageTextObject> textObjects = [
    //RichMessageTextObject()
  ];

  RichMessageTextObject? focusedNode;

  void _onTapEmpty(TapDownDetails details) {
    if (focusedNode == null) {
      textObjects.add(RichMessageTextObject(
        initialPosition: Matrix4.translation(vector_math_64.Vector3(
          details.localPosition.dx, details.localPosition.dy, 0,
        ))
      ));
    } else {
      focusedNode = null;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapEmpty,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all()
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            for (RichMessageTextObject obj in textObjects) DraggableTextLayer(
              obj: obj,
              onFocused: () {
                print("Focus ${obj}");
                focusedNode = obj;
              }
            ),
          ],
        ),
      ),
    );
  }
}

class DraggableTextLayer extends StatefulWidget {
  final RichMessageTextObject obj;
  final void Function()? onFocused;

  const DraggableTextLayer({
    Key? key,
    required this.obj,
    this.onFocused,
  }) : super(key: key);

  @override
  _DraggableTextLayerState createState() => _DraggableTextLayerState();
}

class _DraggableTextLayerState extends State<DraggableTextLayer> {
  final ValueNotifier<Matrix4> notifier = ValueNotifier(Matrix4.identity());
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    notifier.value = widget.obj.initialPosition!;
    _focusNode.addListener(_focusChanged);
    _focusNode.requestFocus();
    super.initState();
  }

  void _focusChanged() {
    if (_focusNode.hasFocus) {
      widget.onFocused?.call();
    }
  }

  void _textChanged(String value) {
    widget.obj.text = value;
  }

  @override
  Widget build(BuildContext context) {
    return MatrixGestureDetector(
        onMatrixUpdate: (m, tm, sm, rm) {
          notifier.value = m;
        },
        child: AnimatedBuilder(
            animation: notifier,
            builder: (context, child) {
              return Container(
                transform: notifier.value,
                // decoration: BoxDecoration(
                //   border: Border.all(),
                // ),
                child: TextField(
                  controller: _textController,
                  onChanged: _textChanged,
                  focusNode: _focusNode,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    //border: InputBorder.none,
                  ),
                  minLines: null,
                  maxLines: null,
                  style: TextStyle(
                    fontSize: 40,
                  ),
                ),
              );
            }
        ),
    );
  }
}
