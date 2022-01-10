import 'dart:convert';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:mailman/entity/postcard_job_entity.dart';
import 'package:mailman/model/rich_message_data.dart';
import 'package:meta/meta.dart';
import 'package:mailman/model/address.dart';

@immutable
class Postcard extends Equatable {
  final File? frontImage;
  final String? frontImageUrl;
  final File? messageImage;
  final String? messageImageUrl;
  final RichMessageData? messageData;
  final bool isLandscape;

  final String? message;
  final Address? sender;
  final Address? recipient;

  final DateTime? sendOn;
  final DateTime? timeSent;
  final String? status;
  final int? id;

  const Postcard({
    this.frontImage,
    this.frontImageUrl,
    this.messageImage,
    this.messageImageUrl,
    this.messageData,
    this.isLandscape = true,
    this.message,
    this.sender,
    this.recipient,
    this.sendOn,
    this.timeSent,
    this.status,
    this.id,
  });

  bool hasFrontImage() {
    return frontImage != null || frontImageUrl != null;
  }

  bool isValid() {
    return hasFrontImage() &&
        message != null &&
        sender != null &&
        recipient != null;
  }

  Postcard copyWith({
    File? frontImage,
    String? frontImageUrl,
    File? messageImage,
    String? messageImageUrl,
    RichMessageData? messageData,
    bool? isLandscape,
    String? message,
    Address? sender,
    Address? recipient,
  }) => Postcard(
    frontImage: frontImage ?? this.frontImage,
    frontImageUrl: frontImageUrl ?? this.frontImageUrl,
    messageImage: messageImage ?? this.messageImage,
    messageImageUrl: messageImageUrl ?? this.messageImageUrl,
    messageData: messageData ?? this.messageData,
    isLandscape: isLandscape ?? this.isLandscape,
    message: message ?? this.message,
    sender: sender ?? this.sender,
    recipient: recipient ?? this.recipient,
  );
  
  PostcardJobEntity toJobEntity() => 
      PostcardJobEntity(
        sender: sender?.toEntity(),
        recipient: recipient?.toEntity(),
        message: message,
        frontImage: frontImage != null ? base64Encode(frontImage!.readAsBytesSync()) : null,
        messageImage: messageImage != null ? base64Encode(messageImage!.readAsBytesSync()) : null,
        richMessageData: messageData != null ? messageData!.toEntity().toJson() : null,
        id: id,
      );
  
  static Postcard fromJobEntity(PostcardJobEntity entity) =>
      Postcard(
        frontImageUrl: entity.frontImageUrl,
        messageImageUrl: entity.messageImageUrl,
        isLandscape: entity.isLandscape ?? true,
        sender: entity.sender != null ? Address.fromEntity(entity.sender!) : null,
        recipient: entity.recipient != null ? Address.fromEntity(entity.recipient!) : null,
        sendOn: entity.sendOn,
        timeSent: entity.timeSent,
        message: entity.message,
        status: entity.status,
        id: entity.id,
      );
  
  @override
  List<Object?> get props => [
  ];
}