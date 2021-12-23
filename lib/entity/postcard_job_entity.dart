import 'package:equatable/equatable.dart';
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
  final String? messageImageUrl;
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
    this.messageImageUrl,
    this.isLandscape,
    this.backImage,
    this.message,
    this.sender,
    this.recipient,
  });

  static PostcardJobEntity fromJson(Map<String, dynamic> json) =>
      PostcardJobEntity(
        id: json[_fieldId],
        status: json[_fieldStatus],
        sendOn: DateTime.parse(json[_fieldSendOn]),
        timeSent: json[_fieldTimeSent] != null ? DateTime.parse(json[_fieldTimeSent]) : null,
        frontImageUrl: json[_fieldFrontImage],
        messageImageUrl: json[_fieldMessageImage],
        isLandscape: json[_fieldIsLandscape],
        message: json[_fieldMessage],
        sender: AddressEntity.fromJson(json[_fieldSender]),
        recipient: AddressEntity.fromJson(json[_fieldRecipient]),
      );

  Map<String, dynamic> toJson() => {
    if (id != null) _fieldId: id,
    if (sender != null) _fieldSenderId: sender!.id,
    if (recipient != null) _fieldRecipientId: recipient!.id,
    if (message != null) _fieldMessage: message,
    if (frontImage != null) _fieldFrontImage: frontImage,
  };

  @override
  List<Object?> get props => [
    id,
    status,
    sendOn,
    timeSent,
  ];
}