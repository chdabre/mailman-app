import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mailman/entity/rich_message_data_entity.dart';

class TextAlignSerializable {
  final String name;
  final TextAlign textAlign;

  const TextAlignSerializable._(this.name, this.textAlign);

  static const left = TextAlignSerializable._('left', TextAlign.left);
  static const center = TextAlignSerializable._('center', TextAlign.center);
  static const right = TextAlignSerializable._('right', TextAlign.right);

  static const values = [left, center, right];

  static TextAlignSerializable parse(String name) {
    return values.firstWhere((element) => element.name == name);
  }

  static TextAlignSerializable getSerializable(TextAlign textAlign) {
    return values.firstWhere((element) => element.textAlign == textAlign);
  }
}

class TextAlignVerticalSerializable {
  final String name;
  final TextAlignVertical textAlignVertical;

  const TextAlignVerticalSerializable._(this.name, this.textAlignVertical);

  static const top = TextAlignVerticalSerializable._('left', TextAlignVertical.top);
  static const center = TextAlignVerticalSerializable._('center', TextAlignVertical.center);
  static const bottom = TextAlignVerticalSerializable._('right', TextAlignVertical.bottom);

  static const values = [top, center, bottom];

  static TextAlignVerticalSerializable parse(String name) {
    return values.firstWhere((element) => element.name == name);
  }

  static TextAlignVerticalSerializable getSerializable(TextAlignVertical textAlignVertical) {
    return values.firstWhere((element) => element.textAlignVertical == textAlignVertical);
  }
}

@immutable
class RichMessageData extends Equatable {
  final String message;
  final double fontSize;
  final String fontFamily;
  final Color color;
  final TextAlign textAlign;
  final TextAlignVertical textAlignVertical;

  const RichMessageData({
    required this.message,
    required this.fontSize,
    required this.fontFamily,
    required this.color,
    required this.textAlign,
    required this.textAlignVertical,
  });

  RichMessageData copyWith({
    String? message,
    double? fontSize,
    String? fontFamily,
    Color? color,
    TextAlign? textAlign,
    TextAlignVertical? textAlignVertical,
  }) => RichMessageData(
    message: message ?? this.message,
    fontSize: fontSize ?? this.fontSize,
    fontFamily: fontFamily ?? this.fontFamily,
    color: color ?? this.color,
    textAlign: textAlign ?? this.textAlign,
    textAlignVertical: textAlignVertical ?? this.textAlignVertical,
  );

  static const RichMessageData empty = RichMessageData(
    message: '',
    fontSize: 60,
    fontFamily: 'Roboto',
    color: Colors.black,
    textAlign: TextAlign.center,
    textAlignVertical: TextAlignVertical.center,
  );

  static RichMessageData fromEntity(RichMessageDataEntity entity) => RichMessageData.empty.copyWith(
    message: entity.message,
    fontSize: entity.fontSize,
    fontFamily: entity.fontFamily,
    color: entity.color != null ? Color(int.parse(entity.color!.split('(0x')[1].split(')')[0])) : null,
    textAlign: entity.textAlign != null ? TextAlignSerializable.parse(entity.textAlign!).textAlign : null,
    textAlignVertical: entity.textAlignVertical != null ? TextAlignVerticalSerializable.parse(entity.textAlignVertical!).textAlignVertical : null,
  );

  RichMessageDataEntity toEntity() => RichMessageDataEntity(
    message: message,
    fontSize: fontSize,
    fontFamily: fontFamily,
    color: '#${color.value.toRadixString(16)}',
    textAlign: TextAlignSerializable.getSerializable(textAlign).name,
    textAlignVertical: TextAlignVerticalSerializable.getSerializable(textAlignVertical).name,
  );

  TextStyle get textStyle => GoogleFonts.getFont(fontFamily).copyWith(
    fontSize: fontSize,
    color: color,
  );

  @override
  List<Object?> get props => [
    message,
    fontSize,
    textAlign,
    textAlignVertical,
  ];
}