import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:vector_math/vector_math_64.dart' as vector_math_64;
import 'package:matrix_gesture_detector/matrix_gesture_detector.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

Future<dynamic> showEditRichMessageModal(BuildContext context, String? message) {
  return showCupertinoModalBottomSheet(
      context: context,
      enableDrag: false,
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

class RichMessageTextObject extends ChangeNotifier {
  final String text;
  final TextStyle style;
  final ValueNotifier<Matrix4> matrix = ValueNotifier(Matrix4.translationValues(8, 8, 0));
  final String id = const Uuid().v4();


  Size? bounds;
  TextPainter? painter;
  bool selected = false;

  RichMessageTextObject(this.text, {
      this.style = const TextStyle(
        color: Colors.black,
        fontSize: 28,
      ),
  }) {
    matrix.addListener(() => notifyListeners());
  }

  @override
  String toString() {
    return "[\"$text\"]";
  }

  TextPainter getPainter({double? maxWidth}) {
    if (painter == null) {
      TextSpan span = TextSpan(
        style: style,
        text: text,
      );

      TextPainter tp = TextPainter(
        text: span,
        textAlign: TextAlign.left,
        textDirection: TextDirection.ltr,
      );
      tp.layout(maxWidth: maxWidth ?? double.infinity);
      painter = tp;
    }
    return painter!;
  }

  bool testHit(double x, double y) {
    Matrix4 T = Matrix4.zero();
    T.copyInverse(matrix.value);

    var hitPos = vector_math_64.Vector3(x, y, 0);
    var hitT = T.transform3(hitPos);
    var size = getPainter().size;

    return 0 <= hitT.x && hitT.x <= size.width && 0 <= hitT.y && hitT.y <= size.height;
  }

  void setSelected(bool selected) {
    this.selected = selected;
    notifyListeners();
  }

  void reset() {
    matrix.value = Matrix4.translationValues(8, 8, 0);
    notifyListeners();
  }
}

class RichMessageEditor extends StatefulWidget {
  const RichMessageEditor({Key? key}) : super(key: key);

  @override
  _RichMessageEditorState createState() => _RichMessageEditorState();
}

class _RichMessageEditorState extends State<RichMessageEditor> {
  final ValueNotifier<Matrix4>? _notifier = ValueNotifier(Matrix4.identity());
  final List<RichMessageTextObject> _objects = [];

  RichMessageTextObject? _selected;

  @override
  void initState() {
    _objects.add(RichMessageTextObject("Lorem Ipsum dolor sit amet consectutir adpiscing elit."));
    _objects.add(RichMessageTextObject("Dini mueter"));
    super.initState();
  }

  void _onMatrixUpdate(Matrix4 m, tm, sm, rm) {
    _notifier!.value = m;
    _selected?.matrix.value = m ;
  }

  void _onTap(TapDownDetails details) {
    _selected = null;
    for (RichMessageTextObject object in _objects) {
      var hit = object.testHit(details.localPosition.dx, details.localPosition.dy);
      object.setSelected(false);
      if (hit) {
        _selected?.setSelected(false);
        _selected = object;
        _selected?.setSelected(true);
      }
    }
    _notifier?.notifyListeners();
    setState(() {});
  }

  void _onDoubleTap() {
    _selected?.reset();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTap,
      onDoubleTap: _onDoubleTap,
      child: MatrixGestureDetector(
        key: Key(_selected?.id ?? "_"),
        focalPointAlignment: Alignment.center,
        onMatrixUpdate: _onMatrixUpdate,
        child: CustomPaint(
          painter: RichMessagePainter(context,
            objects: _objects,
            notifier: _notifier,
          ),
          child: Container(),
        ),
      ),
    );
  }
}

class RichMessagePainter extends CustomPainter {
  final ValueNotifier<Matrix4>? notifier;
  final List<RichMessageTextObject> objects;
  late BuildContext context;

  RichMessagePainter(this.context, {
    required this.objects,
    required this.notifier,
  }) : super(repaint: notifier);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    for (RichMessageTextObject textObject in objects) {
      var painter = RichMessageTextObjectPainter(textObject);
      painter.paint(canvas, size);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class RichMessageTextObjectPainter extends CustomPainter {
  final RichMessageTextObject object;

  RichMessageTextObjectPainter(this.object) : super(repaint: object);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.transform(object.matrix.value.storage);

    var tp = object.getPainter(maxWidth: size.width - 16);
    tp.paint(canvas, Offset.zero);

    var textSize = tp.size;

    if (object.selected) {
      var paint = Paint()
        ..color = Colors.black
        ..strokeWidth = 1
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      canvas.drawRect(Rect.fromLTWH(0, 0, textSize.width, textSize.height), paint);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(RichMessageTextObjectPainter oldDelegate) {
    return true;
  }
}
