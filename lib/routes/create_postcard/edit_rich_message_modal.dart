import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mailman/model/rich_message_data.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:mailman/image_utils.dart';

class RichMessageEditResult {
  final RichMessageData messageData;
  final File textImage;

  RichMessageEditResult({
    required this.messageData,
    required this.textImage,
  });
}

Future<dynamic> showEditRichMessageModal(BuildContext context, RichMessageData? message) {
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
  final RichMessageData? message;

  const EditMessageModalView({
    Key? key,
    this.message,
  }) : super(key: key);

  @override
  _EditMessageModalViewState createState() => _EditMessageModalViewState();
}

class _EditMessageModalViewState extends State<EditMessageModalView> {
  late RichMessageData messageData;
  final _messageEditor = GlobalKey<RichMessageEditorState>();

  bool working = false;

  @override
  void initState() {
    messageData = widget.message ?? RichMessageData.empty;
    super.initState();
  }

  void _messageChanged(RichMessageData value) {
    messageData = value;
    setState(() {});
  }

  void _confirmButtonPressed() async {
    setState(() { working = true; });
    final textImage = await _messageEditor.currentState!.toImageFile();
    final textImageResized = await ImageUtils.resizeImageMaintainOrientation(textImage, width: 720, height: 744);

    Navigator.pop(context, RichMessageEditResult(
        messageData: messageData,
        textImage: textImageResized,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            RichMessageEditor(
              key: _messageEditor,
              message: messageData,
              onMessageChanged: _messageChanged
            ),
            const Spacer(),
            const SizedBox(height: 16,),
            ElevatedButton(
                onPressed: !working ? _confirmButtonPressed : null,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                  elevation: 0,
                ),
                child: working ? SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Theme.of(context).disabledColor,
                  ),
                ) : Text("Confirm".toUpperCase())
            ),
          ],
        ),
      ),
    );
  }
}

class RichMessageEditor extends StatefulWidget {
  const RichMessageEditor({
    Key? key,
    required this.message,
    required this.onMessageChanged,
  }) : super(key: key);

  final RichMessageData message;
  final void Function(RichMessageData value) onMessageChanged;

  @override
  RichMessageEditorState createState() => RichMessageEditorState();
}

class RichMessageEditorState extends State<RichMessageEditor> {
  final _screenshotController = ScreenshotController();
  final _messageController = TextEditingController();
  final _textFieldFocusNode = FocusNode();

  @override
  void initState() {
    _messageController.text = widget.message.message;
    super.initState();
  }

  Future<File> toImageFile() async {
    final image = await _screenshotController.captureFromWidget(
      _buildScreenshotContext(_buildEditField(isPreview: true)),
      pixelRatio: 4,
    );
    final directory = await getTemporaryDirectory();
    final imageFile = await File('${directory.path}/message_${widget.message.hashCode}.png').create();
    return imageFile.writeAsBytes(image.toList());
  }

  Widget _buildScreenshotContext(Widget child) {
    return AspectRatio(
      aspectRatio: 720 / 744,
      child: MediaQuery(
        data: const MediaQueryData(),
        child: Localizations(
          locale: const Locale('en'),
          delegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          child: Material(
            child: child,
            color: Colors.white,
          )
        ),
      ),
    );
  }

  void _onTextSizeChanged(double value) {
    widget.onMessageChanged.call(widget.message.copyWith(
      fontSize: value,
    ));
  }

  void _onMessageChanged(String value) {
    widget.onMessageChanged.call(widget.message.copyWith(
      message: value,
    ));
  }

  void _onTextAlignChanged(TextAlign value) {
    widget.onMessageChanged.call(widget.message.copyWith(
      textAlign: value,
    ));
  }

  void _onTextAlignVerticalChanged(TextAlignVertical value) {
    widget.onMessageChanged.call(widget.message.copyWith(
      textAlignVertical: value,
    ));
  }

  void _onFontChanged(String value) {
    widget.onMessageChanged.call(widget.message.copyWith(
      fontFamily: value,
    ));
  }

  Widget _buildEditField({bool isPreview = false}) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: AspectRatio(
          aspectRatio: 720 / 744,
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              TextField(
                controller: _messageController,
                focusNode: _textFieldFocusNode,
                onChanged: _onMessageChanged,
                style: widget.message.textStyle,
                textAlign: widget.message.textAlign,
                textAlignVertical: widget.message.textAlignVertical,
                decoration: InputDecoration(
                  enabledBorder: isPreview ? const OutlineInputBorder(borderSide: BorderSide(
                    color: Colors.transparent,
                  )) : null,
                  border: const OutlineInputBorder(),
                  label: !isPreview ? Center(child: Text("Tap to Edit Text",
                    style: Theme.of(context).textTheme.bodyText2,
                  ),) : null,
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                ),
                minLines: null,
                maxLines: null,
                expands: true,
                scrollPhysics: const NeverScrollableScrollPhysics(),
              ),
              if (_textFieldFocusNode.hasPrimaryFocus && !isPreview) IconButton(
                onPressed: _textFieldFocusNode.unfocus,
                splashRadius: 16,
                //color: Theme.of(context).primaryColor,
                icon: const Icon(Icons.check_circle),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLayoutOptions() {
    return Row(
      children: [
        Expanded(
          child: Slider(
            value: widget.message.fontSize,
            min: 10,
            max: 120,
            onChanged: _onTextSizeChanged,
          ),
        ),
        IconButtonSelect<TextAlign>(
          choices: const [
            TextAlign.left,
            TextAlign.center,
            TextAlign.right
          ],
          icons: const [
            Icons.format_align_left,
            Icons.format_align_center,
            Icons.format_align_right
          ],
          selection: widget.message.textAlign,
          onChanged: _onTextAlignChanged,
        ),
        IconButtonSelect<TextAlignVertical>(
          choices: const [
            TextAlignVertical.top,
            TextAlignVertical.center,
            TextAlignVertical.bottom
          ],
          icons: const [
            Icons.vertical_align_top,
            Icons.vertical_align_center,
            Icons.vertical_align_bottom
          ],
          selection: widget.message.textAlignVertical,
          onChanged: _onTextAlignVerticalChanged,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildEditField(),
        const SizedBox(height: 8),
        _buildLayoutOptions(),
        const Divider(),
        FontPicker(
          fontChoices: const [
            'Rubik',
            'Fugaz One',
            'Playfair Display',
            'Bebas Neue',
            'Dancing Script',
            'Indie Flower',
            'Permanent Marker'
          ],
          selection: widget.message.fontFamily,
          onSelect: _onFontChanged,
        ),
      ],
    );
  }
}

class FontPicker extends StatelessWidget {
  const FontPicker({
    Key? key,
    required this.fontChoices,
    required this.selection,
    required this.onSelect,
  }) : super(key: key);
  
  final List<String> fontChoices;
  final String selection;
  final void Function(String value) onSelect;
  
  Widget _buildFontRadioButton(BuildContext context, {
    required String fontName,
    bool selected = false,
  }) {
    return TextButton(
      onPressed: () => onSelect.call(fontName),
      style: TextButton.styleFrom(
        backgroundColor: Colors.black.withOpacity(0.01),
        shape: CircleBorder(
          side: BorderSide(
            color: selected ? Theme.of(context).primaryColor : Theme.of(context).disabledColor,
            width: selected ? 2 : 1,
          )
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: Text("Aa",
            style: GoogleFonts.getFont(fontName).copyWith(
              color: selected ? Theme.of(context).primaryColor : Theme.of(context).colorScheme.onSurface,
              fontSize: 16,
            ),
        ),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: fontChoices.map<Widget>((choice) => _buildFontRadioButton(
            context,
            fontName: choice,
            selected: selection == choice,
          )).toList(),
        ),
      ),
    );
  }
}


class IconButtonSelect<T> extends StatelessWidget {
  const IconButtonSelect({
    Key? key,
    required this.choices,
    required this.icons,
    required this.onChanged,
    this.selection,
    this.defaultChoice,
  }) : super(key: key);

  final void Function(T value) onChanged;

  final List<T> choices;
  final List<IconData> icons;
  final T? selection;
  final T? defaultChoice;

  T _getSelection() {
    return selection ?? defaultChoice ?? choices[0];
  }

  int _getSelectionIndex() {
    return choices.indexOf(_getSelection());
  }

  T _nextSelection() {
    var nextIndex = (_getSelectionIndex() + 1) % choices.length ;
    return choices[nextIndex];
  }

  IconData _getIcon() {
    return icons[_getSelectionIndex()];
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => onChanged.call(_nextSelection()),
      icon: Icon(_getIcon()),
    );
  }
}
