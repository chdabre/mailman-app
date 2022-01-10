import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class RichMessageDataEntity extends Equatable {
  static const String _fieldId = 'pk';
  static const String _fieldMessage = 'message';
  static const String _fieldFontSize = 'font_size';
  static const String _fieldFontFamily = 'font_family';
  static const String _fieldColor = 'color';
  static const String _fieldTextAlign = 'text_align';
  static const String _fieldTextAlignVertical = 'text_align_vertical';

  final int? id;
  final String? message;
  final double? fontSize;
  final String? fontFamily;
  final String? color;
  final String? textAlign;
  final String? textAlignVertical;

  const RichMessageDataEntity({
    this.id,
    this.message,
    this.fontSize,
    this.fontFamily,
    this.color,
    this.textAlign,
    this.textAlignVertical,
  });

  static RichMessageDataEntity fromJson(Map<String, dynamic> json) =>
      RichMessageDataEntity(
        id: json[_fieldId],
        message: json[_fieldMessage],
        fontSize: json[_fieldFontSize],
        fontFamily: json[_fieldFontFamily],
        color: json[_fieldColor],
        textAlign: json[_fieldTextAlign],
        textAlignVertical: json[_fieldTextAlignVertical],
      );

  Map<String, dynamic> toJson() => {
    if (id != null) _fieldId: id,
    if (message != null) _fieldMessage: message,
    if (fontSize != null) _fieldFontSize: fontSize,
    if (fontFamily != null) _fieldFontFamily: fontFamily,
    if (color != null) _fieldColor: color,
    if (textAlign != null) _fieldTextAlign: textAlign,
    if (textAlignVertical != null) _fieldTextAlignVertical: textAlignVertical,
  };

  @override
  List<Object?> get props => [
    id,
  ];
}