import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

import 'address_entity.dart';

@immutable
class PostcardJobEntity extends Equatable {
  static const String _fieldId = 'id';
  static const String _fieldStatus = 'status';
  static const String _fieldSendOn = 'send_on';
  static const String _fieldTimeSent = 'time_sent';
  static const String _fieldFrontImage = 'front_image';
  static const String _fieldMessageImage = 'text_image';
  static const String _fieldRichMessageData = 'rich_message_data';
  static const String _fieldIsLandscape = 'is_landscape';
  static const String _fieldMessage = 'message';
  static const String _fieldSender = 'sender';
  static const String _fieldSenderId = 'sender_id';
  static const String _fieldRecipient = 'recipient';
  static const String _fieldRecipientId = 'recipient_id';

  final int? id;
  final String? status;
  final DateTime? sendOn;
  final DateTime? timeSent;

  final String? frontImage;
  final String? frontImageUrl;
  final String? messageImage;
  final String? messageImageUrl;
  final Map<String, dynamic>? richMessageData;
  final bool? isLandscape;
  final String? backImage;
  final String? message;

  final AddressEntity? sender;
  final AddressEntity? recipient;

  const PostcardJobEntity({
    this.id,
    this.status,
    this.sendOn,
    this.timeSent,
    this.frontImage,
    this.frontImageUrl,
    this.messageImage,
    this.messageImageUrl,
    this.richMessageData,
    this.isLandscape,
    this.backImage,
    this.message,
    this.sender,
    this.recipient,
  });

  static PostcardJobEntity fromJson(Map<String, dynamic> jsonData) =>
      PostcardJobEntity(
        id: jsonData[_fieldId],
        status: jsonData[_fieldStatus],
        sendOn: DateTime.parse(jsonData[_fieldSendOn]).toLocal(),
        timeSent: jsonData[_fieldTimeSent] != null ? DateTime.parse(jsonData[_fieldTimeSent]).toLocal() : null,
        frontImageUrl: jsonData[_fieldFrontImage],
        messageImageUrl: jsonData[_fieldMessageImage],
        richMessageData: jsonData[_fieldRichMessageData] != null ? json.decode(jsonData[_fieldRichMessageData]): null,
        isLandscape: jsonData[_fieldIsLandscape],
        message: jsonData[_fieldMessage],
        sender: AddressEntity.fromJson(jsonData[_fieldSender]),
        recipient: AddressEntity.fromJson(jsonData[_fieldRecipient]),
      );

  Map<String, dynamic> toJson() => {
    if (id != null) _fieldId: id,
    if (sender != null) _fieldSenderId: sender!.id,
    if (recipient != null) _fieldRecipientId: recipient!.id,
    if (message != null) _fieldMessage: message,
    if (frontImage != null) _fieldFrontImage: frontImage,
    if (messageImage != null) _fieldMessageImage: messageImage,
    if (richMessageData != null) _fieldRichMessageData: json.encode(richMessageData),
  };

  @override
  List<Object?> get props => [
    id,
    status,
    sendOn,
    timeSent,
  ];
}